extends Node2D

@onready var moveService: MoveService = $MoveService
@onready var menuService: MenuService = $MenuService
@onready var turnService: TurnService = $TurnService
@onready var actionService: ActionService = $ActionService
@onready var aiMoveService: AiMoveService = $AiMoveService
@onready var tileMap: MainTileMap = $TileMap
@onready var highlightMap: HighlightMap = $HighlightMap
var current_turn_id: int = -1
var state: State = State.new()
var _is_ai_turn := false
var _orig_ai_delay := 2.0
var _ai_delay := 0.0
var _do_ai_delay := false
var _ai_callable: Callable

signal ai_delay_done


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
            ai_delay_done.emit()
            
func importTestData():
    var arr = []
    var base_effect = func (user: Entity, entities: Array[Entity]):
        user.threat += user.damage
        for _ent in entities:
            _ent.loseHP(user.damage)
        return
        
    var ent = _add_test_entity("Warrior", 10, 4, 10, Vector2i(0, 1), "res://character_body_2d.tscn", true)
    _add_test_action(ent, "ATTACK", 1, false, 0, 0, [], base_effect, true, ActionType.ATTACK)
    var other_effect = func (user: Entity, targets: Array[Entity], _state_: State):
        user.movement_penalty = 3
        user.threat += 2
        user.threat += user.damage
        for _ent in targets:
            _ent.loseHP(user.damage + 2)
        return
    _add_test_action(ent, "Exert", 1, false, 0, 3, [], other_effect, true, ActionType.ACTION1)
    other_effect = func (user: Entity, targets: Array[Entity]):
        user.immune_count = 1
        return
    _add_test_action(ent, "Take Cover", 0, true, 0, 2, [], other_effect, false, ActionType.ACTION2)
    
    
    ent = _add_test_entity("Rogue", 10, 5, 10, Vector2i(0, 2), "res://character_body_2d.tscn", true)
    _add_test_action(ent, "NAME", 1, false, 0, 0, [], base_effect, true, ActionType.ATTACK)
    other_effect = func (user: Entity, targets: Array[Entity]):
        user.immune_count = 1
        return
    _add_test_action(ent, "NAME", 0, true, 0, 2, [], other_effect, true, ActionType.ACTION1)
    other_effect = func (user: Entity, targets: Array[Entity]):
        user.immune_count = 1
        return
    _add_test_action(ent, "NAME", 0, true, 0, 2, [], other_effect, false, ActionType.ACTION2)
    
    
    
    ent = _add_test_entity("Wizard", 10, 3, 10, Vector2i(0, 2), "res://character_body_2d.tscn", true)
    _add_test_action(ent, "NAME", 4, false, 0, 0, [], base_effect, true, ActionType.ATTACK)
    other_effect = func (user: Entity, entities: Array[Entity]):
        for _ent in entities:
            _ent.loseHP(user.damage + 1)
        return
    arr = [
        Vector2i(1,0), Vector2i(0,1), Vector2i(-1,0), Vector2i(0,-1),
        Vector2i(1,1), Vector2i(1,-1), Vector2i(-1,1), Vector2i(-1,-1)
        ]
    _add_test_action(ent, "NAME", 4, true, 0, 3, arr, other_effect, false, ActionType.ACTION1)
    other_effect = func (user: Entity, entities: Array[Entity]):
        for _ent in entities:
            _ent.shield_amount = 2
            _ent.shield_count = 1
        return
    _add_test_action(ent, "NAME", 4, true, 0, 3, arr, other_effect, true, ActionType.ACTION1)
    
    ent = _add_test_entity("Priest", 10, 3, 10, Vector2i(0, 3), "res://character_body_2d.tscn", true)
    _add_test_action(ent, "NAME", 4, false, 0, 0, [], null, true, ActionType.ATTACK)
    ent = _add_test_entity("Bard", 10, 4, 10, Vector2i(0, 4), "res://character_body_2d.tscn", true)
    _add_test_action(ent, "NAME", 1, false, 0, 0, [], null, true, ActionType.ATTACK)
    ent = _add_test_entity("Archer", 10, 4, 10, Vector2i(0, 4), "res://character_body_2d.tscn", true)
    _add_test_action(ent, "NAME", 5, false, 0, 0, [], null, true, ActionType.ATTACK)
    ent = _add_test_entity("Boss", 100, 6, 14, Vector2i(10,-3), "res://enemy1.tscn", false)
    _add_test_action(ent, "NAME", 1, false, 0, 0, [], null, true, ActionType.ATTACK)
    
    arr = [Vector2i(1,-1), Vector2i(1,0), Vector2i(1,1)]
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
    ent.damage = 2
    ent.display_name = display_name
    ent.health = health
    ent.movement = movement
    ent.speed = speed
    ent.location = location
    var sprite: EntitySprite  = load(sprite_path).instantiate()
    add_child(sprite)
    sprite.global_position = tileMap.pointToGlobal(ent.location)
    sprite.setMaxHP(ent.health)
    sprite.setHP(ent.health)
    ent.sprite = sprite
    if ally:
        var _id = state.addAlly(ent)
        sprite.setLabel(str(_id))
    else:
        var _id = state.addEnemy(ent)
        sprite.setLabel(str(_id))
    return ent

func currentEntity() -> Entity:
    return state.entities.get_data(current_turn_id)

func nextTurn():
    highlightMap.clearHighlight()
    current_turn_id = turnService.startNextTurn()
    menuService.showCurrentTurn(current_turn_id)
    menuService.showTurns(turnService.next5Turns())
    highlightMap.highlight(currentEntity())
    currentEntity().moves_left = currentEntity().movement
    menuService.setMoveNum(currentEntity().moves_left)
    if state.allies.has(current_turn_id):
        _is_ai_turn = false
        menuService.enableAllButtons()
    else:
        _is_ai_turn = true
        menuService.disableAllButtons()
        doAiMove()
    return
    
func startAiDelay():
    _ai_delay = _orig_ai_delay
    _do_ai_delay = true
    return

func doAiMove():
    aiMoveService.start(currentEntity())
    var movePath = aiMoveService.find_move()
    _ai_callable = func ():
        aiMoveService.showPath(movePath)
        movesFound(tileMap.arrayToGlobal(movePath), movePath[-1])
    ai_delay_done.connect(_ai_callable)
    startAiDelay()
    return
    

func doneAiMove():
    return
    

func doMove():
    moveService.start(currentEntity())
    return

func movesFound(poses, destination):
    var numMoves := len(poses)
    currentEntity().sprite.movePoints(poses)
    currentEntity().location = destination
    currentEntity().sprite.doneMoving.connect(doneMove)
    currentEntity().moves_left -= numMoves
    menuService.setMoveNum(currentEntity().moves_left)
    if currentEntity().moves_left == 0:
        menuService.disableMovesButton()
    return

func doneMove():
    currentEntity().sprite.doneMoving.disconnect(doneMove)
    if _is_ai_turn:
        ai_delay_done.disconnect(_ai_callable)
        aiMoveService.finish()
        nextTurn()
    else:
        moveService.finish()
    highlightMap.highlight(currentEntity())
    return

func doAction(idx: int):
    actionService.start(currentEntity(), idx)
    return

func actionDone():
    menuService.disableActionButtons()
    return
