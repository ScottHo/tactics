extends Node2D

@onready var moveService: MoveService = $MoveService
@onready var menuService: MenuService = $MenuService
@onready var turnService: TurnService = $TurnService
@onready var actionService: ActionService = $ActionService
@onready var aiMoveService: AiMoveService = $AiMoveService
@onready var aiActionService: AiActionService = $AiActionService
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
    var arr = []
    var base_effect = func (user: Entity, targets: Array):
        user.threat += user.damage
        for _ent in targets:
            _ent.loseHP(user.damage)
        return
        
        
    var ent = _add_test_entity("Brutis", 10, 4, 10, Vector2i(0, 1), "res://character_body_2d.tscn", true)
    _add_test_action(ent, "Attack", 1, false, 0, 0, [], base_effect, true, ActionType.ATTACK)
    var other_effect = func (user: Entity, targets: Array):
        user.movement_penalty = 3
        user.threat += 2
        user.threat += user.damage
        for _ent in targets:
            _ent.loseHP(user.damage + 2)
        return
    _add_test_action(ent, "Exert", 1, false, 0, 3, [], other_effect, true, ActionType.ACTION1)
    other_effect = func (user: Entity, targets: Array):
        user.immune_count = 1
        return
    _add_test_action(ent, "Take Cover", 0, true, 0, 2, [], other_effect, false, ActionType.ACTION2)
    
    
    ent = _add_test_entity("Oilee", 10, 5, 10, Vector2i(0, 2), "res://character_body_2d.tscn", true)
    _add_test_action(ent, "Attack", 1, false, 0, 0, [], base_effect, true, ActionType.ATTACK)
    other_effect = func (user: Entity, targets: Array):
        for _ent in targets:
            _ent.loseHP(user.damage)
            _ent.movement_penalty = 3
        return
    _add_test_action(ent, "Sticky Grenade", 3, false, 0, 2, [], other_effect, true, ActionType.ACTION1)
    other_effect = func (user: Entity, targets: Array):
        user.moves_left = user.movement
        return
    _add_test_action(ent, "Refuel", 0, true, 0, 2, [], other_effect, true, ActionType.ACTION2)
    
    
    ent = _add_test_entity("Electo", 10, 3, 10, Vector2i(0, 3), "res://character_body_2d.tscn", true)
    _add_test_action(ent, "Attack", 4, false, 0, 0, [], base_effect, true, ActionType.ATTACK)
    other_effect = func (user: Entity, targets: Array):
        for _ent in targets:
            _ent.loseHP(user.damage + 1)
        return
    arr = [
        Vector2i(1,0), Vector2i(0,1), Vector2i(-1,0), Vector2i(0,-1),
        Vector2i(1,1), Vector2i(1,-1), Vector2i(-1,1), Vector2i(-1,-1)
        ]
    _add_test_action(ent, "Storm", 4, true, 0, 3, arr, other_effect, false, ActionType.ACTION1)
    other_effect = func (user: Entity, targets: Array):
        for _ent in targets:
            _ent.shield_amount = 2
            _ent.shield_count = 1
        return
    _add_test_action(ent, "Static Shield", 4, true, 0, 3, arr, other_effect, true, ActionType.ACTION2)
    
    
    ent = _add_test_entity("Nano-nano", 10, 3, 10, Vector2i(0, 4), "res://character_body_2d.tscn", true)
    _add_test_action(ent, "Attack", 4, false, 0, 0, [], base_effect, true, ActionType.ATTACK)
    other_effect = func (user: Entity, targets: Array):
        for _ent in targets:
            _ent.gainHP(6)
        return
    _add_test_action(ent, "Focused Repair", 4, true, 0, 2, [], other_effect, true, ActionType.ACTION1)
    arr = [
        Vector2i(1,0), Vector2i(0,1), Vector2i(-1,0), Vector2i(0,-1),
        Vector2i(1,1), Vector2i(1,-1), Vector2i(-1,1), Vector2i(-1,-1)
        ]
    other_effect = func (user: Entity, targets: Array):
        for _ent in targets:
            _ent.gainHP(3)
        return
    _add_test_action(ent, "Nanofield", 4, true, 0, 2, arr, other_effect, true, ActionType.ACTION2)
    
    
    ent = _add_test_entity("Smithy", 10, 4, 10, Vector2i(0, 5), "res://character_body_2d.tscn", true)
    _add_test_action(ent, "Attack", 1, false, 0, 0, [], base_effect, true, ActionType.ATTACK)
    other_effect = func (user: Entity, targets: Array):
        for _ent in targets:
            _ent.damage += 1
        return
    _add_test_action(ent, "Weapons Upgrade", 1, false, 0, 2, [], other_effect, true, ActionType.ACTION1)
    other_effect = func (user: Entity, targets: Array):
        for _ent in targets:
            _ent.movement += 1
        return
    _add_test_action(ent, "Engine Upgrade", 1, false, 0, 2, [], base_effect, true, ActionType.ACTION2)


    ent = _add_test_entity("Longshot", 10, 4, 10, Vector2i(0, 6), "res://character_body_2d.tscn", true)
    _add_test_action(ent, "Attack", 5, false, 0, 0, [], base_effect, true, ActionType.ATTACK)
    other_effect = func (user: Entity, targets: Array):
        for _ent in targets:
            _ent.loseHP(user.damage)
        return
    _add_test_action(ent, "Snipe", 8, false, 0, 1, [], other_effect, true, ActionType.ACTION1)
    other_effect = func (user: Entity, targets: Array):
        for _ent in targets:
            _ent.loseHP(user.damage + 3)
        return
    _add_test_action(ent, "Titanium Bullet", 5, false, 0, 5, [], other_effect, true, ActionType.ACTION2)
    
    ent = _add_test_entity("Boss", 100, 6, 14, Vector2i(10,-3), "res://enemy1.tscn", false)
    ent.damage += 2
    _add_test_action(ent, "Attack", 1, false, 0, 0, [], base_effect, true, ActionType.ATTACK)
    return

func _add_test_action(ent, display_name, range, self_castable, threat, cost, shape, effect, offensive, action_type):
    var action = Action.new()
    action.range = range
    action.shape = shape
    action.effect = effect
    action.threat = threat
    action.cost = cost
    action.self_castable = self_castable
    action.display_name = display_name
    if offensive:
        action.target_color = Highlights.RED
    else:
        action.target_color = Highlights.BLUE
    if action_type == ActionType.ATTACK:
        ent.attack = action
    if action_type == ActionType.ACTION1:
        ent.action1 = action
    if action_type == ActionType.ACTION2:
        ent.action2 = action
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
    menuService.showTurns(turnService.next5Turns())
    highlightMap.highlight(currentEntity())
    currentEntity().moves_left = currentEntity().movement
    currentEntity().energy += 1
    menuService.setMoveNum(currentEntity().moves_left)
    if state.allies.has(current_turn_id):
        _is_ai_turn = false
        menuService.enableAllButtons()
    else:
        _is_ai_turn = true
        menuService.disableAllButtons()
        startAiMove()
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
            nextTurn()
        return
    _ai_callable = func ():
        aiActionService.do_attack(location)
        aiActionService.finish()
        if not checkDeaths():
            nextTurn()
    startAiDelay()
    return

func doMove():
    moveService.start(currentEntity())
    return

func movesFound(poses):
    currentEntity().sprite.movePoints(poses)
    currentEntity().sprite.doneMoving.connect(doneMove)
    menuService.setMoveNum(currentEntity().moves_left)
    if currentEntity().moves_left == 0:
        menuService.disableMovesButton()
    return

func doneMove():
    currentEntity().sprite.doneMoving.disconnect(doneMove)
    if _is_ai_turn:
        aiMoveService.finish()
        startAiAction()
    else:
        moveService.finish()
    highlightMap.highlight(currentEntity())
    return

func doAction(action_type: int):
    actionService.start(currentEntity(), action_type)
    return

func actionDone():
    menuService.disableActionButtons()
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
        nextTurn()
    return
    
