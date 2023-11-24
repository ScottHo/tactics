class_name MenuService extends Node2D

var _state: State
signal moveActionInitiate
signal nextTurnActionInitiate
signal interactActionInitiate
signal actionInitiate
@onready var moveButton: Button = $Control/MoveButton
@onready var nextTurnButton: Button = $Control/TurnButton
@onready var interactButton: Button = $Control/InteractButton
@onready var action1Button: Button = $Control/ActionContainer/Action1Button
@onready var action2Button: Button = $Control/ActionContainer/Action2Button
@onready var action3Button: Button = $Control/ActionContainer/Action3Button
@onready var action4Button: Button = $Control/ActionContainer/Action4Button
@onready var numMovesLabel: Label = $Control/NumMovesLabel
@onready var currentTurnLabel: Label = $Control/TurnLabelsContainer/CurrentTurnLabel
@onready var futureTurnsLabel: Label = $Control/TurnLabelsContainer/FutureTurnsLabel


# Called when the node enters the scene tree for the first time.
func _ready():
    moveButton.button_down.connect(func(): moveActionInitiate.emit())
    nextTurnButton.button_down.connect(func(): nextTurnActionInitiate.emit())
    interactButton.button_down.connect(func(): interactActionInitiate.emit())
    action1Button.button_down.connect(func(): actionInitiate.emit(0))
    action2Button.button_down.connect(func(): actionInitiate.emit(1))
    action3Button.button_down.connect(func(): actionInitiate.emit(2))
    action4Button.button_down.connect(func(): actionInitiate.emit(3))
    return

func setState(state: State):
    _state = state
    return

func setMoveNum(i: int):
    numMovesLabel.text = str(i)
    return

func showTurns(turns: Array[int]):
    futureTurnsLabel.text = str(turns)
    return

func showCurrentTurn(turn: int):
    currentTurnLabel.text = str(turn)
    return
