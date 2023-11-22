class_name MenuService extends Node2D

var _state: State
signal moveActionInitiate
signal nextTurnActionInitiate
@onready var moveButton = $Control/Button
@onready var label = $Control/Label
# Called when the node enters the scene tree for the first time.
func _ready():
    moveButton.button_down.connect(emitMoveButton)
    $Control/Button2.button_down.connect(emitNextTurn)
    pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
    pass

func setState(state: State):
    _state = state
    return

func emitMoveButton():
    moveActionInitiate.emit()
    return

func emitNextTurn():
    nextTurnActionInitiate.emit()
    return

func setMoveNum(i: int):
    label.text = str(i)
    return

func showTurns(turns: Array[int]):
    $Control/Label2.text = str(turns)
    return

func showCurrentTurn(turn: int):
    $Control/Label3.text = str(turn)
    return
