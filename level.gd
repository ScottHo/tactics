extends Node2D

@onready var moveService: MoveService = $MoveService
@onready var menuService: MenuService = $Camera2D/CanvasLayer/MenuService
@onready var turnService: TurnService = $TurnService
@onready var actionService: ActionService = $ActionService
@onready var aiMoveService: AiMoveService = $AiMoveService
@onready var aiActionService: AiActionService = $AiActionService
@onready var aiSpecialService: AiSpecialService = $AiSpecialService
@onready var deathService: DeathService = $DeathService
@onready var infoService: InfoService = $InfoService
@onready var interactService: InteractService = $InteractService
@onready var tileMap: MainTileMap = $TileMap
@onready var highlightMap: HighlightMap = $HighlightMap
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
    moveService.movesFound.connect(movesFound)
    actionService.actionDone.connect(actionDone)
    interactService.interactDone.connect(interactDone)
    importTestData()
    
    actionService.setState(state)
    moveService.setState(state)
    aiMoveService.setState(state)
    aiActionService.setState(state)
    aiSpecialService.setState(state)
    deathService.setState(state)
    turnService.setState(state)
    infoService.setState(state)
    interactService.setState(state)    
    infoService.start()
    turnService.update()
    menuService.setState(state)
    menuService.updateAllEntities()
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

func importTestData():
    print("Importing Test Data")
    var ent = _add_test_entity("Brutis", 10, 4, 1, 10, Vector2i(0, 0), "res://brutus.tscn", true)
    ActionFactory.add_base_attack(ent)
    ActionFactory.add_exert(ent, ActionType.ACTION1)
    ActionFactory.add_take_cover(ent, ActionType.ACTION2)
    
    ent = _add_test_entity("Oilee", 10, 5, 1, 10, Vector2i(0, 1), "res://oilee.tscn", true)
    ActionFactory.add_base_attack(ent)
    ActionFactory.add_sticky_grenade(ent, ActionType.ACTION1)
    ActionFactory.add_refuel(ent, ActionType.ACTION2)

    ent = _add_test_entity("Electo", 10, 3, 4, 10, Vector2i(0, 2), "res://electo.tscn", true)
    ActionFactory.add_base_attack(ent)
    ActionFactory.add_storm(ent, ActionType.ACTION1)
    ActionFactory.add_static_shield(ent, ActionType.ACTION2)
    
    ent = _add_test_entity("Nano-nano", 10, 3, 4, 10, Vector2i(0, 3), "res://nanonano.tscn", true)
    ActionFactory.add_base_attack(ent)
    ActionFactory.add_focused_repair(ent, ActionType.ACTION1)
    ActionFactory.add_nano_field(ent, ActionType.ACTION2)
    
    ent = _add_test_entity("Smithy", 10, 4, 1, 10, Vector2i(0, 4), "res://smithy.tscn", true)
    ActionFactory.add_base_attack(ent)
    ActionFactory.add_weapons_upgade(ent, ActionType.ACTION1)
    ActionFactory.add_engine_upgrade(ent, ActionType.ACTION2)

    ent = _add_test_entity("Longshot", 10, 4, 5, 10, Vector2i(0, 5), "res://longshot.tscn", true)
    ActionFactory.add_base_attack(ent)
    ActionFactory.add_snipe(ent, ActionType.ACTION1)
    ActionFactory.add_titanium_bullet(ent, ActionType.ACTION2)
    
    ent = _add_test_entity("Boss", 50, 6, 1, 10, Vector2i(11, 2), "res://enemy_1.tscn", false)
    ent.damage += 2
    ActionFactory.add_base_attack(ent)
    
    var _inter = Interactable.new()
    _inter.display_name = "Blue Orb Buff Thing"
    _inter.description = "Pick up for +4 damage, but -4 movement"
    _inter.effect = func (user: Entity):
        user.damage_modifier += 4
        user.movement_modifier -= 4
        return

    _inter.drop_effect = func (user: Entity):
        user.damage_modifier -= 4
        user.movement_modifier += 4
        return

    _inter.repeated_effect = func (user: Entity):
        print("repeat")
        return
    _inter.storable = true
    _inter.location = Vector2i(4,2)
    var sprite: Sprite2D  = Sprite2D.new()
    sprite.texture = load("res://Assets/blue_orb.png")
    sprite.scale = Vector2(.5, .5)
    _inter.sprite = sprite
    add_child(sprite)
    sprite.global_position = tileMap.pointToGlobal(_inter.location)
    state.add_interactable(_inter)
    return

func _add_test_entity(display_name, health, movement, _range, speed, location, sprite_path, ally):
    var ent = Entity.new()
    var sprite: EntitySprite  = load(sprite_path).instantiate()
    add_child(sprite)
    sprite.global_position = tileMap.pointToGlobal(location)
    ent.sprite = sprite
    ent.alive = true
    ent.damage = 2
    ent.display_name = display_name
    ent.set_hp(health)
    ent.movement = movement
    ent.range = _range
    ent.speed = speed
    ent.location = location
    ent.update_energy(1)
    ent.set_max_hp(health)
    ent.setThreat(0)
    if ally:
        var _id = state.addAlly(ent)
    else:
        var _id = state.addEnemy(ent)
        ent.energy = 0
    return ent

func currentEntity() -> Entity:
    return state.entities.get_data(current_turn_id)

func nextTurn():
    if currentEntity() != null:
        currentEntity().reset_buff_values()
    highlightMap.clearHighlight()
    current_turn_id = turnService.startNextTurn()
    resetPlayerServices()
    menuService.showTurns(turnService.next10Turns())
    currentEntity().setup_next_turn()
    if state.allies.has(current_turn_id):
        _is_ai_turn = false
        menuService.enableAllButtons()
        if currentEntity().get_movement() == 0:
            menuService.disableMovesButton()
    else:
        _is_ai_turn = true
        menuService.disableAllButtons()
        nextAiStep()
    update_character_menu()
    menuService.showCurrentTurn(current_turn_id)    
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
    menuService.updateAllEntities()
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
    aiSpecialService.start(currentEntity())
    menuService.set_mechanic_text(aiSpecialService.next_special_description())
    if aiSpecialService.counter() == 0:
        nextAiStep()
        return
    aiSpecialService.special_targets()
    _ai_callable = doAiSpecial
    startAiDelay()
    return

func doAiSpecial():
    aiSpecialService.special_effect()
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
    menuService.updateAllEntities()    
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
        currentEntity().sprite.movePoints(poses)
    else:
        doneMove()
    return

func doneMove():
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
    
