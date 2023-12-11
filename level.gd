extends Node2D

@onready var moveService: MoveService = $MoveService
@onready var menuService: MenuService = $MenuService
@onready var turnService: TurnService = $TurnService
@onready var actionService: ActionService = $ActionService
@onready var aiMoveService: AiMoveService = $AiMoveService
@onready var aiActionService: AiActionService = $AiActionService
@onready var aiSpecialService: AiSpecialService = $AiSpecialService
@onready var deathService: DeathService = $DeathService
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
    moveService.movesFound.connect(movesFound)
    actionService.actionDone.connect(actionDone)
    importTestData()
    
    actionService.setState(state)
    moveService.setState(state)
    aiMoveService.setState(state)
    aiActionService.setState(state)
    aiSpecialService.setState(state)
    deathService.setState(state)
    turnService.setState(state)
    turnService.update()
    menuService.setState(state)
    menuService.showTurns(turnService.next5Turns())
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
    var ent = _add_test_entity("Brutis", 10, 4, 10, Vector2i(0, 1), "res://character_1.tscn", true)
    ActionFactory.add_base_attack(ent, 1)
    ActionFactory.add_exert(ent, ActionType.ACTION1)
    ActionFactory.add_take_cover(ent, ActionType.ACTION2)
    
    ent = _add_test_entity("Oilee", 10, 5, 10, Vector2i(0, 2), "res://character_1.tscn", true)
    ActionFactory.add_base_attack(ent, 1)
    ActionFactory.add_sticky_grenade(ent, ActionType.ACTION1)
    ActionFactory.add_refuel(ent, ActionType.ACTION2)

    ent = _add_test_entity("Electo", 10, 3, 10, Vector2i(0, 3), "res://character_1.tscn", true)
    ActionFactory.add_base_attack(ent, 4)
    ActionFactory.add_storm(ent, ActionType.ACTION1)
    ActionFactory.add_static_shield(ent, ActionType.ACTION2)
    
    ent = _add_test_entity("Nano-nano", 10, 3, 10, Vector2i(0, 4), "res://character_1.tscn", true)
    ActionFactory.add_base_attack(ent, 4)
    ActionFactory.add_focused_repair(ent, ActionType.ACTION1)
    ActionFactory.add_nano_field(ent, ActionType.ACTION2)
    
    ent = _add_test_entity("Smithy", 10, 4, 10, Vector2i(0, 5), "res://character_1.tscn", true)
    ActionFactory.add_base_attack(ent, 1)
    ActionFactory.add_weapons_upgade(ent, ActionType.ACTION1)
    ActionFactory.add_engine_upgrade(ent, ActionType.ACTION2)

    ent = _add_test_entity("Longshot", 10, 4, 10, Vector2i(0, 6), "res://character_1.tscn", true)
    ActionFactory.add_base_attack(ent, 5)
    ActionFactory.add_snipe(ent, ActionType.ACTION1)
    ActionFactory.add_titanium_bullet(ent, ActionType.ACTION2)
    
    ent = _add_test_entity("Boss", 100, 6, 14, Vector2i(10,-3), "res://enemy_1.tscn", false)
    ent.damage += 2
    ActionFactory.add_base_attack(ent, 1)
    return

func _add_test_entity(display_name, health, movement, speed, location, sprite_path, ally):
    var ent = Entity.new()
    ent.alive = true
    ent.damage = 2
    ent.display_name = display_name
    ent.max_health = health
    ent.health = health
    ent.movement = movement
    ent.speed = speed
    ent.location = location
    ent.energy = 1
    var sprite: EntitySprite  = load(sprite_path).instantiate()
    add_child(sprite)
    sprite.global_position = tileMap.pointToGlobal(ent.location)
    sprite.setMaxHP(ent.health)
    sprite.setHP(ent.health)
    ent.sprite = sprite
    sprite.setLabel(ent.display_name)
    ent.setThreat(0)    
    if ally:
        var _id = state.addAlly(ent)
    else:
        var _id = state.addEnemy(ent)
    return ent

func currentEntity() -> Entity:
    return state.entities.get_data(current_turn_id)

func nextTurn():
    highlightMap.clearHighlight()
    current_turn_id = turnService.startNextTurn()
    resetPlayerServices()
    menuService.showTurns(turnService.next5Turns())
    currentEntity().moves_left = currentEntity().movement
    currentEntity().energy += 1
    menuService.setMoveNum(currentEntity().moves_left)
    if state.allies.has(current_turn_id):
        currentEntity().loseThreat(1)
        _is_ai_turn = false
        menuService.enableAllButtons()
    else:
        _is_ai_turn = true
        menuService.disableAllButtons()
        nextAiStep()
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
        if not checkDeaths():
            nextAiStep()
        return
    _ai_callable = func ():
        aiActionService.do_attack(location)
        aiActionService.finish()
        if not checkDeaths():
            nextAiStep()
    startAiDelay()
    return

func startAiSpecial():
    aiSpecialService.start(currentEntity())
    if aiSpecialService.counter() == 0:
        menuService.set_mechanic_text(aiSpecialService.next_special_description())
        nextAiStep()
        return
    aiSpecialService.special_targets()
    _ai_callable = doAiSpecial
    startAiDelay()
    return

func doAiSpecial():
    aiSpecialService.special_effect()
    aiSpecialService.finish()
    if not checkDeaths():
        nextAiStep()
    return

func resetPlayerServices():
    moveService.finish()
    actionService.finish()
    highlightMap.highlight(currentEntity())
    return

func doMove():
    resetPlayerServices()
    moveService.start(currentEntity())
    return

func movesFound(poses):
    currentEntity().sprite.doneMoving.connect(doneMove)    
    if len(poses) > 0:
        currentEntity().sprite.movePoints(poses)
        menuService.setMoveNum(currentEntity().moves_left)
        if currentEntity().moves_left == 0:
            menuService.disableMovesButton()
    else:
        doneMove()
    return

func doneMove():
    currentEntity().sprite.doneMoving.disconnect(doneMove)
    if _is_ai_turn:
        aiMoveService.finish()
        nextAiStep()
    else:
        moveService.finish()
    highlightMap.highlight(currentEntity())
    return

func doAction(action_type: int):
    resetPlayerServices()
    actionService.start(currentEntity(), action_type)
    var d = ""
    if action_type == ActionType.ATTACK:
        d = currentEntity().attack.description
    if action_type == ActionType.ACTION1:
        d = currentEntity().action1.description
    if action_type == ActionType.ACTION2:
        d = currentEntity().action2.description
    menuService.set_description_text(d)
    return

func actionDone():
    menuService.disableActionButtons()
    menuService.updateEnergy(currentEntity().energy)
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
    
