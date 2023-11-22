class_name MenuService extends Node2D

var _state: State
signal moveActionInitiate
signal nextTurnActionInitiate
signal interactActionInitiate
signal action1Initiate
signal action2Initiate
signal action3Initiate
signal action4Initiate
@onready var moveButton: Button = $Control/MoveButton
@onready var nextTurnButton: Button = $Control/TurnButton
@onready var interactButton: Button = $Control/InteractButton
@onready var action1Button: Button = $Control/ActionTree/Action1Button
@onready var action2Button: Button = $Control/ActionTree/Action2Button
@onready var action3Button: Button = $Control/ActionTree/Action3Button
@onready var action4Button: Button = $Control/ActionTree/Action4Button
@onready var numMovesLabel: Label = $Control/NumMovesLabel
@onready var currentTurnLabel: Label = $Control/TurnLabelsContainer/CurrentTurnLabel
@onready var futureTurnsLabel: Label = $Control/TurnLabelsContainer/FutureTurnsLabel


# Called when the node enters the scene tree for the first time.
func _ready():
    moveButton.button_down.connect(func(): moveActionInitiate.emit())
    nextTurnButton.button_down.connect(func(): nextTurnActionInitiate.emit())
    interactButton.button_down.connect(func(): interactActionInitiate.emit())
    action1Button.button_down.connect(func(): action1Initiate.emit())
    action2Button.button_down.connect(func(): action2Initiate.emit())
    action3Button.button_down.connect(func(): action3Initiate.emit())
    action4Button.button_down.connect(func(): action4Initiate.emit())
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
