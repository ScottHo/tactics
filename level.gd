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
    
    importTestData()
    
    moveService.setState(state)
    moveService.updateEntityLocations()
    turnService.setState(state)
    turnService.update()
    menuService.setState(state)
    menuService.showTurns(turnService.next5Turns())
    nextTurn()
    return

func importTestData():
    var ally1 = Entity.new()
    ally1.health = 10
    ally1.movement = 6
    ally1.speed = 10
    ally1.location = Vector2i(1,0)
    var sprite1 = load("res://character_body_2d.tscn").instantiate()
    add_child(sprite1)
    sprite1.global_position = tileMap.pointToGlobal(ally1.location)
    ally1.sprite = sprite1
    var id1 = state.addAlly(ally1)
    sprite1.setLabel(str(id1))
    var ally2 = Entity.new()
    ally2.health = 10
    ally2.movement = 10
    ally2.speed = 8
    ally2.location = Vector2i(1,1)
    var sprite2 = load("res://character_body_2d.tscn").instantiate()
    add_child(sprite2)
    sprite2.global_position = tileMap.pointToGlobal(ally2.location)
    ally2.sprite = sprite2
    var id2 = state.addAlly(ally2)
    sprite2.setLabel(str(id2))
    var ally3 = Entity.new()
    ally3.health = 10
    ally3.movement = 10
    ally3.speed = 12
    ally3.location = Vector2i(1,2)
    var sprite3 = load("res://character_body_2d.tscn").instantiate()
    add_child(sprite3)
    sprite3.global_position = tileMap.pointToGlobal(ally3.location)
    ally3.sprite = sprite3
    var id3 = state.addAlly(ally3)
    sprite3.setLabel(str(id3))
    var ally4 = Entity.new()
    ally4.health = 10
    ally4.movement = 10
    ally4.speed = 14
    ally4.location = Vector2i(1,3)
    var sprite4  = load("res://character_body_2d.tscn").instantiate()
    add_child(sprite4)
    sprite4.global_position = tileMap.pointToGlobal(ally4.location)
    ally4.sprite = sprite4
    var id4 = state.addAlly(ally4)
    sprite4.setLabel(str(id4))
    
    var action = Action.new()
    action.range = 5
    action.damage = 5
    var arr : Array[Vector2i] = [Vector2i(1,0), Vector2i(-1,0)]
    action.shape = arr 
    actionService.setAction(0, action)
    
    action = Action.new()
    action.range = 6
    action.damage = 5
    arr = [
        Vector2i(1,0), Vector2i(0,1), Vector2i(-1,0), Vector2i(0,-1),
        Vector2i(1,1), Vector2i(1,-1), Vector2i(-1,1), Vector2i(-1,-1)
        ]
    action.shape = arr
    actionService.setAction(1, action)
    
    action = Action.new()
    action.range = 1
    action.damage = 10
    arr = [Vector2i(1,-1), Vector2i(1,0), Vector2i(1,1)]
    action.shape = arr
    actionService.setAction(2, action)
    
    action = Action.new()
    action.range = 5
    action.damage = 5
    arr = []
    action.shape = arr
    actionService.setAction(3, action)
    return

func currentEntity() -> Entity:
    return state.entities.get_data(current_turn_id)

func nextTurn():
    highlightMap.clearHighlight()
    current_turn_id = turnService.startNextTurn()
    menuService.showCurrentTurn(current_turn_id)
    menuService.showTurns(turnService.next5Turns())
    highlightMap.highlight(currentEntity())
    return

func doMove():
    moveService.numMovesUpdated.connect(menuService.setMoveNum)
    moveService.start(currentEntity())
    return

func movesFound(poses, destination: Vector2i):
    var entity: Entity = state.entities.get_data(current_turn_id)
    currentEntity().sprite.movePoints(poses)
    currentEntity().location = destination
    currentEntity().sprite.doneMoving.connect(doneMove)
    return

func doneMove():
    moveService.numMovesUpdated.disconnect(menuService.setMoveNum)
    currentEntity().sprite.doneMoving.disconnect(doneMove)
    moveService.finish()
    moveService.updateEntityLocations()
    menuService.setMoveNum(0)
    highlightMap.highlight(currentEntity())
    return

func doAction(idx: int):
    actionService.start(currentEntity(), idx)
    return
    
