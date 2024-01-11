extends Node2D

@onready var moveService: MoveService = $MoveService
@onready var menuService: MenuService = $Camera2D/CanvasLayer/MenuService
@onready var turnService: TurnService = $TurnService
@onready var actionService: ActionService = $ActionService
@onready var aiMoveService: AiMoveService = $AiMoveService
@onready var aiActionService: AiActionService = $AiActionService
@onready var aiSpecialService: AiSpecialService = $AiSpecialService
@onready var deathService: DeathService = $DeathService
@onready var interactService: InteractService = $InteractService
@onready var cameraService: CameraService = $CameraService
@onready var scoreService: ScoreService = $Camera2D/CanvasLayer/ScoreService
@onready var tileMap: MainTileMap = $TileMap
@onready var highlightMap: HighlightMap = $HighlightMap
@onready var timer: Timer = $Timer
var current_turn_id: int = -1
var _mission: Mission
var state: State = State.new()
var _is_first_turn := true
var _is_ai_turn := false
var _special_texts_set := true
var _orig_ai_delay := 2.0
var _ai_delay := 0.0
var _do_ai_delay := false
var _ai_callable: Callable
var _animation_delay := 0.0
var _do_animation_delay := false
var _animation_callback: Callable

enum AiState { NONE, MOVE, ACTION, SPECIAL}
var _ai_state: AiState = AiState.NONE

func _ready():
    menuService.nextTurnActionInitiate.connect(nextTurn)
    menuService.moveActionInitiate.connect(doMove)
    menuService.actionInitiate.connect(doAction)
    menuService.interactActionInitiate.connect(doInteract)
    menuService.menuAnimationsFinished.connect(doNextTurn)
    moveService.movesFound.connect(movesFound)
    actionService.actionDone.connect(actionDone)
    interactService.interactDone.connect(interactDone)
    
    setup_entities()
    
    actionService.setState(state)
    moveService.setState(state)
    aiMoveService.setState(state)
    aiActionService.setState(state)
    aiSpecialService.setState(state)
    deathService.setState(state)
    turnService.setState(state)
    interactService.setState(state)    
    scoreService.setState(state)
    turnService.update()
    menuService.setState(state)
    menuService.showTurns(turnService.next7Turns())
    nextTurn()
    return

func _process(delta):
    if _do_ai_delay:
        _ai_delay -= delta
        if _ai_delay <= 0:
            _do_ai_delay = false
            _ai_callable.call()
    if _do_animation_delay:
        _animation_delay -= delta
        if _animation_delay <= 0.0:
            _do_animation_delay = false
            _animation_callback.call()
    
    return

func setup_entity_for_level(ent: Entity, location: Vector2i):
    var sprite: EntitySprite = load(ent.sprite_path).instantiate()
    add_child(sprite)
    sprite.global_position = tileMap.pointToGlobal(location)
    ent.location = location
    if ent.is_ally:
        var _id = state.addAlly(ent)
        ent.set_energy(1)
    else:
        var _id = state.addEnemy(ent)
    ent.sprite = sprite
    ent.update_sprite()
    ent.damage_done = 0
    return

func setup_entities():
    if Globals.level_debug_mode:
        Globals.current_mission = MissionFactory.foundry_1_final_boss()
        setup_entity_for_level(EntityFactory.create_buster(), Vector2i(4,4))
    else:
        # TODO Custom deploy tiles
        var allies = Globals.entities_to_deploy
        for i in range(len(allies)):
            if allies[i] != null:
                setup_entity_for_level(allies[i], Vector2i(0, i))
    
    _mission = Globals.current_mission
    
    setup_entity_for_level(_mission.boss, Vector2i(9, 2))
    return

func currentEntity() -> Entity:
    return state.entities.get_data(current_turn_id)

func nextTurn():
    if [5, 10, 15].has(scoreService.turnsTaken):
        var location = interactService.spawn_interactable(_mission)
        cameraService.move(tileMap.pointToGlobal(location))
        timer.timeout.connect(nextTurn_continued, CONNECT_ONE_SHOT)
        timer.start(1.6)
        return
    nextTurn_continued()
    return

func nextTurn_continued():
    timer.stop()

    scoreService.turn_taken()
    menuService.disableAllButtons()
    if currentEntity() != null:
        currentEntity().reset_buff_values()
        currentEntity().done_turn()
    highlightMap.clearHighlight()
    current_turn_id = turnService.startNextTurn()
    cameraService.move(tileMap.pointToGlobal(currentEntity().location))
    resetPlayerServices()
    if not currentEntity().is_ally and not currentEntity().is_add:
        _special_texts_set = false
        if not _is_first_turn:
            currentEntity().specials_left = _mission.specials_per_turn
    _is_first_turn = false
    menuService.showTurns(turnService.next7Turns())
    menuService.pre_showCurrentTurn(current_turn_id)
    timer.timeout.connect(nextTurn_continued2, CONNECT_ONE_SHOT)
    timer.start(.4)
    return

func nextTurn_continued2():
    timer.stop()
    currentEntity().setup_next_turn()
    if state.allies.has(current_turn_id):
        _is_ai_turn = false
    else:
        _is_ai_turn = true
    update_character_menu()
    menuService.showCurrentTurn(current_turn_id)
    return

func doNextTurn():
    if _is_ai_turn:
        menuService.disableTurnButton()
        nextAiStep()
    return

func startAnimationDelay(delay: float):
    _animation_delay = delay
    _do_animation_delay = true
    return

func startAiDelay():
    _ai_delay = _orig_ai_delay
    _do_ai_delay = true
    return

func nextAiStep():
    if _ai_state == AiState.NONE:
        _ai_state = AiState.MOVE
        startAiMove()
        return
    if _ai_state == AiState.MOVE:
        _ai_state = AiState.ACTION
        startAiAction()
        return
    if _ai_state == AiState.ACTION:
        if currentEntity().is_add:
            _ai_state = AiState.NONE
            nextTurn()
            return
        _ai_state = AiState.SPECIAL
        startAiSpecial()
        return
    if _ai_state == AiState.SPECIAL:
        currentEntity().specials_left -= 1
        if currentEntity().specials_left <= 0:
            currentEntity().specials_left = 0
            _ai_state = AiState.NONE
            nextTurn()
        else:
            startAiSpecial()
        return
    return

func startAiMove():
    aiMoveService.start(currentEntity())
    var movePath = aiMoveService.find_move()
    _ai_callable = func ():
        aiMoveService.showPath(movePath)
        movesFound(tileMap.arrayToGlobal(movePath))
    startAiDelay()
    return

func startAiAction():
    aiActionService.start(currentEntity())
    _ai_callable = doAiAction
    startAiDelay()
    return

func doAiAction():
    var location = aiActionService.find_attack_location()
    if location == Vector2i(999, 999):
        aiActionService.finish()
        update_character_menu()
        if not checkDeaths():
            nextAiStep()
        return
    _ai_callable = func ():
        aiActionService.do_attack(location)
        aiActionService.finish()
        update_character_menu()
        if not checkDeaths():
            nextAiStep()
    startAiDelay()
    return

func startAiSpecial():
    aiSpecialService.start(currentEntity(), _mission)
    if aiSpecialService.counter() == -1:
        set_ai_special_mechanic_texts()
        nextAiStep()
        return
    aiSpecialService.find_special_targets()
    _ai_callable = doAiSpecial
    startAiDelay()
    return

func doAiSpecial():
    aiSpecialService.do_special_effect()
    set_ai_special_mechanic_texts()
    aiSpecialService.finish()
    turnService.update_new()
    update_character_menu()
    if not checkDeaths():
        nextAiStep()
    return

func set_ai_special_mechanic_texts():
    if _special_texts_set:
        return
    _special_texts_set = true
    menuService.set_mechanic_text_1(aiSpecialService.n_special_name(),
        aiSpecialService.n_special_description())
    if _mission.specials_per_turn > 1:
        menuService.set_mechanic_text_2(aiSpecialService.nn_special_name(),
                aiSpecialService.nn_special_description())
    if _mission.specials_per_turn > 2:
        menuService.set_mechanic_text_3(aiSpecialService.nnn_special_name(),
                aiSpecialService.nnn_special_description())
    return

func resetPlayerServices():
    menuService.force_show_description = false
    menuService.show_description(false, null)
    moveService.finish()
    actionService.finish()
    interactService.finish()
    highlightMap.highlight(currentEntity())
    return

func update_character_menu():
    menuService.updateEntityInfo(currentEntity())
    for entity in state.all_entities():
        if entity.alive:
            entity.update_sprite()
    return

func doMove(on):
    resetPlayerServices()
    if not on:
        return
    if not _is_ai_turn:
        menuService.show_description_click(ActionType.MOVE)
    moveService.start(currentEntity())
    return

func movesFound(poses):
    currentEntity().sprite.doneMoving.connect(doneMove, CONNECT_ONE_SHOT)
    if len(poses) > 0:
        cameraService.lock_on(currentEntity().sprite)
        currentEntity().sprite.movePoints(poses)
    else:
        doneMove()
    return

func doneMove():
    cameraService.stop_lock()
    if currentEntity().moves_left == 0:
        menuService.disableMovesButton()
    if _is_ai_turn:
        aiMoveService.finish()
        nextAiStep()
    else:
        menuService.show_description(false, null)
        menuService.force_show_description = false
        moveService.finish()
    update_character_menu()
    highlightMap.highlight(currentEntity())
    return

func doInteract(on):
    resetPlayerServices()
    if not on:
        return
    interactService.start(currentEntity())
    menuService.show_description_click(ActionType.INTERACT)
    return

func interactDone():
    interactService.finish()
    menuService.disableInteractButton()
    menuService.show_description(false, null)
    menuService.force_show_description = false
    update_character_menu()
    checkDeaths()
    return

func doAction(on, action_type: int):
    resetPlayerServices()
    if not on:
        return
    actionService.start(currentEntity(), action_type)
    menuService.show_description_click(action_type)
    return

func actionDone():
    menuService.disableActionButtons()
    menuService.show_description(false, null)
    menuService.force_show_description = false
    update_character_menu()
    checkDeaths()
    return

func checkDeaths():
    if not deathService.checkDeaths():
        return false
    deathService.processDeaths()
    turnService.updateDeaths()
    _animation_callback = processDeathsFinished
    menuService.cache_button_states()
    menuService.disableAllButtons()
    startAnimationDelay(2)
    return true

func processDeathsFinished():
    if state.all_allies_dead():
        menuService.lose()
        return
    if state.all_enemies_dead():
        menuService.win()
        return
    menuService.restore_button_states()
    if _is_ai_turn:
        nextAiStep()
    return
    
