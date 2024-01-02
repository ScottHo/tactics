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
@onready var tileMap: MainTileMap = $TileMap
@onready var highlightMap: HighlightMap = $HighlightMap
@onready var timer: Timer = $Timer
var current_turn_id: int = -1
var state: State = State.new()
var _is_ai_turn := false
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
    turnService.update()
    menuService.setState(state)
    menuService.showTurns(turnService.next10Turns())
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

func setup_interactable_for_level(inter: Interactable, location: Vector2i):
    inter.location = location
    var sprite: InteractableSprite  = load(inter.sprite_path).instantiate()
    sprite.set_texture(load(inter.icon_path))
    inter.set_sprite(sprite)
    add_child(sprite)
    sprite.global_position = tileMap.pointToGlobal(inter.location)
    state.add_interactable(inter)
    return

func setup_entity_for_level(ent: Entity, location: Vector2i):
    var sprite: EntitySprite  = load(ent.sprite_path).instantiate()
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
    return

func setup_entities():
    if Globals.level_debug_mode:
        Globals.curent_mission = MissionFactory.mission_3()
        setup_entity_for_level(EntityFactory.create_oilee(), Vector2i(0,3))
    else:
        # TODO Custom deploy tiles
        var allies = Globals.entities_to_deploy
        for i in range(len(allies)):
            if allies[i] != null:
                setup_entity_for_level(allies[i], Vector2i(0, i))
        
    # TODO Setup service to randomly put these down
    setup_interactable_for_level(Globals.curent_mission.buffs[0], Vector2i(3,3))
    
    setup_entity_for_level(Globals.curent_mission.boss, Vector2i(9, 2))
    return

func currentEntity() -> Entity:
    return state.entities.get_data(current_turn_id)

func nextTurn():
    menuService.disableAllButtons()
    if currentEntity() != null:
        currentEntity().reset_buff_values()
    highlightMap.clearHighlight()
    current_turn_id = turnService.startNextTurn()
    cameraService.move(tileMap.pointToGlobal(currentEntity().location))    
    resetPlayerServices()
    menuService.showTurns(turnService.next10Turns())
    menuService.pre_showCurrentTurn(current_turn_id)
    timer.timeout.connect(nextTurn_continued)
    timer.start(.4)
    return
    

func nextTurn_continued():
    timer.stop()
    timer.disconnect_all()
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
    _do_animation_delay = delay
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
        _ai_state = AiState.SPECIAL
        startAiSpecial()
        return
    if _ai_state == AiState.SPECIAL:
        _ai_state = AiState.NONE
        nextTurn()
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
    cameraService.reset()
    aiSpecialService.start(currentEntity(), Globals.curent_mission)
    if aiSpecialService.counter() == -1:
        menuService.set_mechanic_text(aiSpecialService.next_special_name(),
                aiSpecialService.next_special_description())    
        nextAiStep()
        return
    aiSpecialService.find_special_targets()
    _ai_callable = doAiSpecial
    startAiDelay()
    return

func doAiSpecial():
    aiSpecialService.do_special_effect()
    menuService.set_mechanic_text(aiSpecialService.next_special_name(),
            aiSpecialService.next_special_description())
    aiSpecialService.finish()
    update_character_menu()
    if not checkDeaths():
        nextAiStep()
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
    currentEntity().sprite.doneMoving.connect(doneMove)
    if len(poses) > 0:
        cameraService.lock_on(currentEntity().sprite)
        currentEntity().sprite.movePoints(poses)
    else:
        doneMove()
    return

func doneMove():
    cameraService.stop_lock()    
    currentEntity().sprite.doneMoving.disconnect(doneMove)
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
    startAnimationDelay(1)
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
    
