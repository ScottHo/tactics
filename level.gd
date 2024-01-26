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
@onready var auraService: AuraService = $AuraService
@onready var tileMap: MainTileMap = $TileMap
@onready var highlightMap: HighlightMap = $HighlightMap
@onready var highlightMap2: HighlightMap2 = $HighlightMap2
@onready var tutorialService: TutorialService = $TutorialService
@onready var timer: Timer = $Timer

var current_turn_id: int = -1
var _mission: Mission
var state: State = State.new()
var _is_first_turn := true
var _is_ai_turn := false
var _start_of_turn := false
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
    aiActionService.done.connect(aiActionDone)
    aiSpecialService.special_done.connect(continue_doAiSpecial)
    
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
    highlightMap2.set_state(state)
    auraService.set_state(state)
    menuService.setState(state)

    turnService.tutorial_mode = _mission.is_tutorial
    menuService.jenkins.tutorial_mode = _mission.is_tutorial
    menuService.tutorial_mode = _mission.is_tutorial
    turnService.update()    
    menuService.showTurns(turnService.next5Turns())
    auraService.update()
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
    ent.health = ent.get_max_health()
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
    if ent.passive != null:
        if ent.passive.is_static:
            ent.passive.static_effect.call(ent)
    return

func setup_entities():
    if Globals.level_debug_mode:
        Globals.current_mission = MissionFactory.foundry_1_final_boss()
        var e := EntityFactory.create_bot(EntityFactory.Bot.LONGSHOT)
        e.action1.level += 1
        e.damage += 2
        var e1 := EntityFactory.create_bot(EntityFactory.Bot.PEPPERSHOT)
        e1.action1.level += 1
        e1.max_health += 2
        var e2 := EntityFactory.create_bot(EntityFactory.Bot.BRUTUS)
        e2.action1.level += 1
        e2.armor += 2
        var e3 := EntityFactory.create_bot(EntityFactory.Bot.ELECTO)
        e3.action1.level += 1
        e3.damage += 2
        var e4 := EntityFactory.create_bot(EntityFactory.Bot.BATTERIE)
        e4.action1.level += 1
        var e5 := EntityFactory.create_bot(EntityFactory.Bot.NANONANO)
        e5.action1.level += 1
        e5.max_health += 2
        var e6 := EntityFactory.create_bot(EntityFactory.Bot.SMITHY)
        e6.action2.level += 1
        e6.max_health += 3
        #setup_entity_for_level(e, Vector2i(1,0))
        setup_entity_for_level(e1, Vector2i(3,2))
        #setup_entity_for_level(e2, Vector2i(1,2))
        setup_entity_for_level(e3, Vector2i(3,3))
        #setup_entity_for_level(e4, Vector2i(3,4))
        #setup_entity_for_level(e5, Vector2i(3,5))
        setup_entity_for_level(e6, Vector2i(3,6))
        #setup_entity_for_level(EntityFactory.create_god_mode(), Vector2i(4,0))
        #setup_entity_for_level(EntityFactory.create_god_mode(), Vector2i(4,1))
        #setup_entity_for_level(EntityFactory.create_god_mode(), Vector2i(4,2))
        #setup_entity_for_level(EntityFactory.create_god_mode(), Vector2i(4,3))
        #setup_entity_for_level(EntityFactory.create_god_mode(), Vector2i(4,5))
    else:
        # TODO Custom deploy tiles
        var allies = Globals.entities_to_deploy
        for i in range(len(allies)):
            if allies[i] != null:
                setup_entity_for_level(allies[i], Vector2i(1, i-1))
    
    _mission = Globals.current_mission
    if _mission.is_tutorial:
        var ent = EntityFactory.create_tutorial_bot()
        ent.action2.level = 1
        setup_entity_for_level(ent, Vector2i(3,3))
        tutorialService.start()
    else:
        menuService.jenkins_talk("This bot looks tough! Good luck.", Jenkins.Mood.NORMAL)
    if _mission.display_name == "Foundry 2F":
        var tiles = tileMap.all_tiles()
        tiles.shuffle()
        for i in range(9):
            tileMap.set_cell(0, tiles[i], 1, Tiles.CRACKED)
        
    setup_entity_for_level(_mission.boss, Vector2i(9, 2))
    return

func currentEntity() -> Entity:
    return state.entities.get_data(current_turn_id)

func nextTurn():
    print_debug("Next Turn")
    _start_of_turn = true
    if currentEntity() != null:
        currentEntity().reset_buff_values()
        currentEntity().done_turn()
        currentEntity().stop_animations()
    if not checkDeaths():
        nextTurn_continued()
    return

func nextTurn_continued():
    if scoreService.turnsTaken != 0 and scoreService.turnsTaken % 5 == 0:
        var location = interactService.spawn_interactable(_mission)
        if location == Vector2i(999,999):
            nextTurn_continued2()
            return
        cameraService.move(tileMap.pointToGlobal(location))
        timer.timeout.connect(nextTurn_continued2, CONNECT_ONE_SHOT)
        timer.start(1.6)
        return
    nextTurn_continued2()
    return

func nextTurn_continued2():
    timer.stop()
    scoreService.turn_taken()
    menuService.disableAllButtons()
    highlightMap.clearHighlight()
    current_turn_id = turnService.startNextTurn()
    cameraService.move(tileMap.pointToGlobal(currentEntity().location))
    resetPlayerServices()
    if not currentEntity().is_ally and not currentEntity().is_add:
        _special_texts_set = false
        if not _is_first_turn:
            currentEntity().specials_left = _mission.specials_per_turn
    _is_first_turn = false
    menuService.showTurns(turnService.next5Turns())
    menuService.pre_showCurrentTurn(current_turn_id)
    timer.timeout.connect(nextTurn_continued3, CONNECT_ONE_SHOT)
    timer.start(.4)
    return

func nextTurn_continued3():
    timer.stop()
    currentEntity().setup_next_turn()
    if state.allies.has(current_turn_id):
        _is_ai_turn = false
    else:
        _is_ai_turn = true
    update_character_menu()
    menuService.showCurrentTurn(current_turn_id)
    _start_of_turn = false
    if _mission.is_tutorial:
        if tutorialService.stage == TutorialService.TutorialStage.EndTurn1:
            tutorialService.next_tutorial_stage()
        elif tutorialService.stage == TutorialService.TutorialStage.DummyTurn1:
            tutorialService.next_tutorial_stage()
        elif tutorialService.stage == TutorialService.TutorialStage.SpecialAttack:
            tutorialService.next_tutorial_stage()
        elif tutorialService.stage == TutorialService.TutorialStage.DummySpecial:
            tutorialService.next_tutorial_stage()
    return

func doNextTurn():
    if _is_ai_turn:
        menuService.disableAllButtons(true)
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
            _special_texts_set = false
            startAiSpecial()
        return
    return

func startAiMove():
    print_debug("Start AI Move")
    aiMoveService.start(currentEntity())
    var movePath = aiMoveService.find_move()
    _ai_callable = func ():
        aiMoveService.showPath(movePath)
        movesFound(tileMap.arrayToGlobal(movePath))
    startAiDelay()
    return

func startAiAction():
    print_debug("Start AI Action")
    aiActionService.start(currentEntity())
    _ai_callable = doAiAction
    startAiDelay()
    return

func doAiAction():
    print_debug("Do AI Action")
    var location = aiActionService.find_attack_location()
    if location == Vector2i(999, 999):
        aiActionService.finish()
        update_character_menu()
        if not checkDeaths():
            nextAiStep()
        return
    aiActionService.do_attack(location)
    return

func aiActionDone():
    print_debug("AI Action Done")
    aiActionService.finish()
    update_character_menu()
    if not checkDeaths():
        nextAiStep()
        return
    return

func startAiSpecial():
    print_debug("Start AI Special")
    aiSpecialService.start(currentEntity(), _mission)
    if aiSpecialService.counter() == -1:
        set_ai_special_mechanic_texts()
        currentEntity().specials_left = 0
        nextAiStep()
        return
    aiSpecialService.find_special_targets()
    _ai_callable = doAiSpecial
    startAiDelay()
    return

func doAiSpecial():
    print_debug("Do AI Special")
    aiSpecialService.do_special_effect()
    return

func continue_doAiSpecial():
    print_debug("Continue Do AI Special")
    set_ai_special_mechanic_texts()
    aiSpecialService.finish()
    turnService.update_new()
    auraService.update()
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
    currentEntity().move_animation()
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
    print_debug("Do Move")
    if not _is_ai_turn:
        menuService.show_description_click(ActionType.MOVE)
    moveService.start(currentEntity())
    return

func movesFound(poses):
    print_debug("Moves Found")
    menuService.disableTurnButton()
    currentEntity().sprite.doneMoving.connect(moveDone, CONNECT_ONE_SHOT)
    if len(poses) > 0:
        cameraService.lock_on(currentEntity().sprite)
        var moved_ents = []
        for pose in poses:
            var tile = tileMap.globalToPoint(pose)
            var ent = state.entity_on_tile(tile)
            if ent != null and currentEntity() !=  ent:
                if currentEntity().is_ally == ent.is_ally:
                    moved_ents.append(ent)
                    continue
            moved_ents.append(null)
        currentEntity().sprite.movePoints(poses, moved_ents)
    else:
        moveDone()
    return

func moveDone():
    if _mission.is_tutorial:
        if tutorialService.stage == TutorialService.TutorialStage.Moves:
            tutorialService.next_tutorial_stage()
    print_debug("Done Move")
    cameraService.stop_lock()
    auraService.update()
    if _is_ai_turn:
        aiMoveService.finish()
        nextAiStep()
    else:
        menuService.show_description(false, null)
        menuService.force_show_description = false
        menuService.restore_button_states()
        moveService.finish()
    if currentEntity().moves_left == 0:
        menuService.disableMovesButton(true)
    Globals.end_action()
    update_character_menu()
    highlightMap.highlight(currentEntity())
    return

func doInteract(on):
    resetPlayerServices()
    if not on:
        return
    print_debug("Do Interact")
    interactService.start(currentEntity())
    menuService.show_description_click(ActionType.INTERACT)
    return

func interactDone():
    print_debug("Interact Done")
    if _mission.is_tutorial:
        if tutorialService.stage == TutorialService.TutorialStage.Turn3:
            tutorialService.next_tutorial_stage()
    interactService.finish()
    menuService.show_description(false, null)
    menuService.force_show_description = false
    update_character_menu()
    if not checkDeaths():
        Globals.end_action()
    return

func doAction(on, action_type: int):
    resetPlayerServices()
    if not on:
        return
    print_debug("Do Action")
    actionService.start(currentEntity(), action_type)
    menuService.show_description_click(action_type)
    return

func actionDone():
    print_debug("Action Done")
    if _mission.is_tutorial:
        if tutorialService.stage == TutorialService.TutorialStage.Attack:
            tutorialService.next_tutorial_stage()
        elif tutorialService.stage == TutorialService.TutorialStage.Turn2:
            tutorialService.next_tutorial_stage()
    menuService.disableActionButtons()
    menuService.show_description(false, null)
    menuService.force_show_description = false
    turnService.update_new()
    auraService.update()
    update_character_menu()
    if not checkDeaths():
        Globals.end_action()
    return

func checkDeaths():
    print_debug("Check Deaths")
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
    print_debug("Process Deaths Finished")
    if state.all_allies_dead():
        menuService.lose()
        return
    if state.boss_dead():
        if _mission.is_tutorial:
            if tutorialService.stage == TutorialService.TutorialStage.Ultimate:
                tutorialService.next_tutorial_stage()
            get_tree().create_timer(3).timeout.connect(menuService.win)
        else:
            menuService.win()
        return
    menuService.restore_button_states()
    if _start_of_turn:
        nextTurn_continued()
        return
    if _is_ai_turn:
        nextAiStep()
    return
    
