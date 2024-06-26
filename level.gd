extends Node2D

@onready var moveService: MoveService = $MoveService
@onready var menuService: MenuService = $Camera2D/CanvasLayer/MenuService
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

var _mission: Mission
var state: State = State.new()
var _is_first_turn := true
var _is_ai_turn := false
var _special_texts_set := true
var _orig_ai_delay := 1.8
var _ai_delay := 0.0
var _do_ai_delay := false
var _ai_callable: Callable
var _animation_delay := 0.0
var _do_animation_delay := false
var _animation_callback: Callable
var current_entity: Entity
var _enemy_entities: Array
var specials_left := 0

enum AiState { NONE, MOVE, ACTION, SPECIAL}
var _ai_state: AiState = AiState.NONE

func _ready():
    menuService.nextTurnActionInitiate.connect(enemyTurn)
    menuService.moveActionInitiate.connect(doMove)
    menuService.actionInitiate.connect(doAction)
    menuService.interactActionInitiate.connect(doInteract)
    menuService.menuAnimationsFinished.connect(doNextTurn)
    menuService.stopAction.connect(resetPlayerServices)
    moveService.movesFound.connect(movesFound)
    actionService.actionDone.connect(actionDone)
    actionService.actionAnimation.connect(actionFound)
    interactService.interactDone.connect(interactDone)
    aiActionService.done.connect(aiActionDone)
    aiSpecialService.special_done.connect(continue_doAiSpecial)
    highlightMap2.new_entity_selected.connect(new_entity)
    
    setup_entities()

    actionService.setState(state)
    moveService.setState(state)
    aiMoveService.setState(state)
    aiActionService.setState(state)
    aiSpecialService.setState(state)
    deathService.setState(state)
    interactService.setState(state)    
    scoreService.setState(state)
    highlightMap2.set_state(state)
    auraService.set_state(state)
    menuService.setState(state)

    menuService.jenkins.tutorial_mode = _mission.is_tutorial
    menuService.tutorial_mode = _mission.is_tutorial
    auraService.update()
    mission_start()
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
    sprite.animation_overrides = ent.animation_overrides
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
        var e := EntityFactory.create_bot(EntityFactory.Bot.SABER)
        e.action1.level += 1
        e.action2.level += 1
        var e1 := EntityFactory.create_bot(EntityFactory.Bot.DRILLBIT)
        e1.action1.level += 1
        e1.action2.level += 1
        var e2 := EntityFactory.create_bot(EntityFactory.Bot.PULSAR)
        e2.action1.level += 1
        e2.action2.level += 1
        var e3 := EntityFactory.create_bot(EntityFactory.Bot.ELECTO)
        e3.action1.level += 1
        e3.action2.level += 1
        var e4 := EntityFactory.create_bot(EntityFactory.Bot.BRUTUS)
        e4.action1.level += 1
        e4.action2.level += 1
        var e5 := EntityFactory.create_bot(EntityFactory.Bot.SMITHY)
        e5.action1.level += 1
        e5.action2.level += 1
        setup_entity_for_level(e, Vector2i(2,0))
        setup_entity_for_level(e1, Vector2i(2,1))
        setup_entity_for_level(e2, Vector2i(2,2))
        setup_entity_for_level(e3, Vector2i(2,3))
        setup_entity_for_level(e4, Vector2i(2,4))
        setup_entity_for_level(e5, Vector2i(2,5))
        #setup_entity_for_level(e6, Vector2i(3,6))
        #setup_entity_for_level(EntityFactory.create_god_mode(), Vector2i(4,0))
        #setup_entity_for_level(EntityFactory.create_god_mode(), Vector2i(4,1))
        #setup_entity_for_level(EntityFactory.create_god_mode(), Vector2i(4,2))
        #setup_entity_for_level(EntityFactory.create_god_mode(), Vector2i(4,3))
        #setup_entity_for_level(EntityFactory.create_god_mode(), Vector2i(4,5))
    else:
        var allies = Globals.entities_to_deploy
        var offset = 0
        if len(allies) < 3:
            offset = 2
        elif len(allies) < 5:
            offset = 1
        for i in range(len(allies)):
            if allies[i] != null:
                setup_entity_for_level(allies[i], Vector2i(2, i+offset))
    
    _mission = Globals.current_mission
    if _mission.is_tutorial:
        var ent = EntityFactory.create_tutorial_bot()
        ent.action2.level = 1
        setup_entity_for_level(ent, Vector2i(3,3))

    if _mission.display_name == "Foundry 2F":
        var tiles = tileMap.all_tiles()
        tiles.shuffle()
        for i in range(9):
            tileMap.set_cell(0, tiles[i], 1, Tiles.CRACKED)
    if _mission.is_mini_boss:
        UiSoundPlayer.play_music("res://Assets/Audio/Amaj-120BPM.wav")
    else:
        UiSoundPlayer.play_music("res://Assets/Audio/Overdrive.wav")
    setup_entity_for_level(_mission.boss, Vector2i(6, 2))
    return

func mission_start():
    menuService.disableAllButtons(true)
    menuService.mission_start()
    cameraService.tween_zoom_in()
    var mid_tile_x = floor((tileMap.MAX_X-tileMap.MIN_X)/2.0) + tileMap.MIN_X
    var mid_tile_y = floor((tileMap.MAX_Y-tileMap.MIN_Y)/2.0) + tileMap.MIN_Y
    cameraService.move(tileMap.pointToGlobal(Vector2i(mid_tile_x, mid_tile_y)))
    var t = get_tree().create_timer(1.5)
    t.timeout.connect(func():
        if _mission.is_tutorial:
            tutorialService.start()
        else:
            menuService.jenkins_talk("This bot looks tough! Good luck.", Jenkins.Mood.NORMAL)
        highlightMap2.start()
        alliedTurn())
    return

func new_entity(e: Entity):
    if Globals.enemy_turn:
        return
    print_debug("New Entity: " + e.display_name)        
    current_entity = e
    current_entity.stop_animations()
    nextTurn()
    return

func enemyTurn():
    Globals.enemy_turn = true
    current_entity = null
    highlightMap.clearHighlight()
    menuService.disableAllButtons(true)
    scoreService.turn_taken()    
    for ent in state.all_allies_alive():
        ent.done_turn()
    _enemy_entities = state.all_enemies_alive()
    for ent in _enemy_entities:
        ent.reset_buff_values()
        ent.setup_next_turn()
    nextAiTurn()
    if tutorialService.stage == TutorialService.TutorialStage.EndTurn1:
        tutorialService.next_tutorial_stage()
    elif tutorialService.stage == TutorialService.TutorialStage.SpecialAttack:
        tutorialService.next_tutorial_stage()
    menuService.show_big_event("Enemy\nTurn")
    return

func alliedTurn():
    Globals.enemy_turn = false    
    highlightMap.clearHighlight()
    current_entity = null
    menuService.disableAllButtons(true)
    scoreService.turn_taken()    
    for ent in state.all_enemies_alive():
        ent.done_turn()

    var locations = []
    for ent in state.all_allies_alive():
        ent.reset_buff_values()
        ent.setup_next_turn()
        locations.append(ent.location)
    cameraService.move_to_array(locations)
    if tutorialService.stage == TutorialService.TutorialStage.DummyTurn1:
        tutorialService.next_tutorial_stage()
    elif tutorialService.stage == TutorialService.TutorialStage.DummySpecial:
        tutorialService.next_tutorial_stage()
    menuService.show_big_event("Your\nTurn")
    menuService.enable_turn_button(true, false)
    return

func nextAiTurn():
    if len(_enemy_entities) == 0:
        alliedTurn()
        return
    current_entity = _enemy_entities.pop_back()
    nextTurn()
    return

func nextTurn():
    print_debug("Next Turn")
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
    highlightMap.clearHighlight()
    cameraService.move(tileMap.pointToGlobal(current_entity.location))
    menuService.pre_showCurrentTurn(current_entity)
    resetPlayerServices()    
    timer.timeout.connect(nextTurn_continued3, CONNECT_ONE_SHOT)
    timer.start(.2)
    return

func nextTurn_continued3():
    timer.stop()
    update_character_menu()
    menuService.showCurrentTurn()
    if _mission.is_tutorial:
        if tutorialService.stage == TutorialService.TutorialStage.Welcome:
            tutorialService.next_tutorial_stage()
    return

func doNextTurn():
    if Globals.enemy_turn:
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
    var t = get_tree().create_timer(.2)
    t.timeout.connect(do_nextAiStep)
    return

func do_nextAiStep():
    if _ai_state == AiState.NONE:
        if current_entity.skip_next_turn:
            current_entity.skip_next_turn = false
            current_entity.custom_text("Knocked Out!", Color.MEDIUM_PURPLE)
            _ai_callable = nextTurn
            startAiDelay()
            return
        _ai_state = AiState.MOVE
        startAiMove()
        return
    if _ai_state == AiState.MOVE:
        _ai_state = AiState.ACTION
        startAiAction()
        return
    if _ai_state == AiState.ACTION:
        if current_entity.is_add:
            _ai_state = AiState.NONE
            nextAiTurn()
            return
        _ai_state = AiState.SPECIAL
        startAiSpecial()
        return
    if _ai_state == AiState.SPECIAL:
        specials_left -= 1
        if specials_left <= 0:
            specials_left = 0
            _ai_state = AiState.NONE
            nextAiTurn()
        else:
            _special_texts_set = false
            startAiSpecial()
        return
    return

func startAiMove():
    print_debug("Start AI Move")    
    aiMoveService.start(current_entity)
    var movePath = aiMoveService.find_move()
    _ai_callable = func ():
        aiMoveService.showPath(movePath)
        movesFound(tileMap.arrayToGlobal(movePath))
    startAiDelay()
    return

func startAiAction():
    print_debug("Start AI Action")
    aiActionService.start(current_entity)
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
    if _mission.specials_per_turn == 0:
        nextAiStep()
        return
    print_debug("Start AI Special")
    aiSpecialService.start(current_entity, _mission)
    if aiSpecialService.counter() == -1:
        set_ai_special_mechanic_texts()
        specials_left = 0
        nextAiStep()
        return
    menuService.show_event(aiSpecialService.special().display_name,
        aiSpecialService.special().description)
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
    auraService.update()
    update_character_menu()
    if not checkDeaths():
        _ai_callable = nextAiStep
        startAiDelay()
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
    highlightMap.highlight(current_entity)
    current_entity.move_animation()
    return

func update_character_menu():
    if _mission.is_tutorial:
        menuService.restore_button_states()
    else:
        menuService.update_button_states()
    menuService.updateEntityInfo()
    for entity in state.all_entities():
        if entity.alive:
            entity.update_sprite()
    return

func doMove(on):
    resetPlayerServices()
    if not on:
        return
    print_debug("Do Move")
    if not Globals.enemy_turn:
        menuService.show_description_click(ActionType.MOVE)
    moveService.start(current_entity)
    return

func movesFound(poses):
    print_debug("Moves Found")
    menuService.enable_turn_button(false, true)
    current_entity.sprite.doneMoving.connect(moveDone, CONNECT_ONE_SHOT)
    if len(poses) > 0:
        cameraService.lock_on(current_entity.sprite)
        var moved_ents = []
        for pose in poses:
            var tile = tileMap.globalToPoint(pose)
            var ent = state.entity_on_tile(tile)
            if ent != null and current_entity !=  ent:
                if current_entity.is_ally == ent.is_ally:
                    moved_ents.append(ent)
                    continue
            moved_ents.append(null)
        current_entity.movePoints(poses, moved_ents)
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
    if Globals.enemy_turn:
        aiMoveService.finish()
        nextAiStep()
    else:
        menuService.show_description(false, null)
        menuService.force_show_description = false
        menuService.update_button_states()
        moveService.finish()
    
    Globals.end_action()
    update_character_menu()
    highlightMap.highlight(current_entity)
    return

func doInteract(on):
    resetPlayerServices()
    if not on:
        return
    print_debug("Do Interact")
    interactService.start(current_entity)
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
    actionService.start(current_entity, action_type)
    menuService.show_description_click(action_type)
    return

func actionFound():
    print("action found")
    menuService.disableAllButtons()
    menuService.enable_turn_button(false, true)
    return

func actionDone():
    print_debug("Action Done")
    current_entity.action_used = true    
    if _mission.is_tutorial:
        if tutorialService.stage == TutorialService.TutorialStage.Attack:
            tutorialService.next_tutorial_stage()
        elif tutorialService.stage == TutorialService.TutorialStage.Turn2:
            tutorialService.next_tutorial_stage()
    menuService.show_description(false, null)
    menuService.force_show_description = false
    auraService.update()
    update_character_menu()
    if not checkDeaths():
        Globals.end_action()
    return

func checkDeaths():
    print_debug("Check Deaths")
    if not deathService.checkDeaths():
        return false
    resetPlayerServices()
    update_character_menu()
    deathService.processDeaths()
    _animation_callback = processDeathsFinished
    menuService.disableAllButtons()
    startAnimationDelay(2.1)
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
    if Globals.enemy_turn:
        nextAiStep()
    update_character_menu()
    return
    
