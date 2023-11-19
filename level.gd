extends Node2D

@onready var moveService: MoveService = $MoveService
@onready var actionService = $ActionService
@onready var turnService: TurnService = $TurnService
var current_turn_id: int = -1
var state: State = State.new()
# Called when the node enters the scene tree for the first time.
func _ready():
    actionService.nextTurnActionInitiate.connect(nextTurn)
    actionService.moveActionInitiate.connect(doMove)
    moveService.movesFound.connect(movesFound)
    
    var ally1 = Entity.new()
    ally1.health = 10
    ally1.movement = 6
    ally1.speed = 10
    var sprite1 = load("res://character_body_2d.tscn").instantiate()
    add_child(sprite1)
    sprite1.global_position = moveService.pointToGlobal(Vector2i(1,0))
    ally1.sprite = sprite1
    var id1 = state.addAlly(ally1)
    sprite1.setLabel(str(id1))
    var ally2 = Entity.new()
    ally2.health = 10
    ally2.movement = 10
    ally2.speed = 8
    var sprite2 = load("res://character_body_2d.tscn").instantiate()
    add_child(sprite2)
    sprite2.global_position = moveService.pointToGlobal(Vector2i(1,1))
    ally2.sprite = sprite2
    var id2 = state.addAlly(ally2)
    sprite2.setLabel(str(id2))
    var ally3 = Entity.new()
    ally3.health = 10
    ally3.movement = 10
    ally3.speed = 12
    var sprite3 = load("res://character_body_2d.tscn").instantiate()
    add_child(sprite3)
    sprite3.global_position = moveService.pointToGlobal(Vector2i(1,2))
    ally3.sprite = sprite3
    var id3 = state.addAlly(ally3)
    sprite3.setLabel(str(id3))
    var ally4 = Entity.new()
    ally4.health = 10
    ally4.movement = 10
    ally4.speed = 14
    var sprite4  = load("res://character_body_2d.tscn").instantiate()
    add_child(sprite4)
    sprite4.global_position = moveService.pointToGlobal(Vector2i(1,3))
    ally4.sprite = sprite4
    var id4 = state.addAlly(ally4)
    sprite4.setLabel(str(id4))

    moveService.setState(state)
    turnService.setState(state)
    turnService.update()
    actionService.setState(state)
    actionService.showTurns(turnService.next5Turns())
    return

func currentEntity() -> Entity:
    return state.entities.get_data(current_turn_id)

func nextTurn():
    current_turn_id = turnService.startNextTurn()
    actionService.showCurrentTurn(current_turn_id)
    actionService.showTurns(turnService.next5Turns())
    return

func doMove():
    moveService.numMovesUpdated.connect(actionService.setMoveNum)
    moveService.start(currentEntity().sprite.global_position)
    return

func movesFound(poses):
    var entity: Entity = state.entities.get_data(current_turn_id)
    currentEntity().sprite.movePoints(poses)
    currentEntity().sprite.doneMoving.connect(doneMove)
    return

func doneMove():
    moveService.numMovesUpdated.disconnect(actionService.setMoveNum)
    currentEntity().sprite.doneMoving.disconnect(doneMove)
    moveService.finish()
    actionService.setMoveNum(0)
    return
    
