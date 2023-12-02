extends Node2D

@onready var moveService: MoveService = $MoveService
@onready var menuService: MenuService = $MenuService
@onready var turnService: TurnService = $TurnService
@onready var actionService: ActionService = $ActionService
@onready var tileMap: MainTileMap = $TileMap
@onready var highlightMap: HighlightMap = $HighlightMap
var current_turn_id: int = -1
var state: State = State.new()


func _ready():
    menuService.nextTurnActionInitiate.connect(nextTurn)
    menuService.moveActionInitiate.connect(doMove)
    menuService.actionInitiate.connect(doAction)
    moveService.movesFound.connect(movesFound)
    actionService.actionDone.connect(actionDone)
    importTestData()
    
    actionService.setState(state)
    moveService.setState(state)
    turnService.setState(state)
    turnService.update()
    menuService.setState(state)
    menuService.showTurns(turnService.next5Turns())
    nextTurn()
    return

func importTestData():
    _add_test_entity(10, 4, 10, Vector2i(1, 1), "res://character_body_2d.tscn", true)
    _add_test_entity(10, 3, 10, Vector2i(1, 2), "res://character_body_2d.tscn", true)
    _add_test_entity(10, 4, 10, Vector2i(1, 3), "res://character_body_2d.tscn", true)
    _add_test_entity(100, 6, 20, Vector2i(4,-4), "res://enemy1.tscn", false)
    
    var arr : Array[Vector2i] = [Vector2i(1,0), Vector2i(-1,0)]
    _add_test_action(5, 5, arr, 0)
    arr = [
        Vector2i(1,0), Vector2i(0,1), Vector2i(-1,0), Vector2i(0,-1),
        Vector2i(1,1), Vector2i(1,-1), Vector2i(-1,1), Vector2i(-1,-1)
        ]
    _add_test_action(6, 5, arr, 1)
    arr = [Vector2i(1,-1), Vector2i(1,0), Vector2i(1,1)]
    _add_test_action(1, 10, arr, 2)
    arr = []
    _add_test_action(5, 5, arr, 3)
    return

func _add_test_action(range, damage, shape, idx):
    var action = Action.new()
    action.range = range
    action.damage = damage
    action.shape = shape
    actionService.setAction(idx, action)
    return

func _add_test_entity(health, movement, speed, location, sprite_path, ally):
    var ent = Entity.new()
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
        var _id = state.addEnemy(ent)
        sprite.setLabel(str(_id))
    else:
        var _id = state.addAlly(ent)
        sprite.setLabel(str(_id))
    return

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
    menuService.enableAllButtons()
    return

func doMove():
    moveService.start(currentEntity())
    return

func movesFound(poses, destination: Vector2i):
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
    moveService.finish()
    highlightMap.highlight(currentEntity())
    return

func doAction(idx: int):
    actionService.start(currentEntity(), idx)
    return

func actionDone():
    menuService.disableActionButtons()
    return
