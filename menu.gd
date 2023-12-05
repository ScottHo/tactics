class_name MenuService extends Node2D

var _state: State
signal moveActionInitiate
signal nextTurnActionInitiate
signal interactActionInitiate
signal actionInitiate
@onready var moveButton: Button = $Control/MoveButton
@onready var nextTurnButton: Button = $Control/TurnButton
@onready var interactButton: Button = $Control/InteractButton
@onready var attackButton: Button = $Control/ActionContainer/AttackButton
@onready var action1Button: Button = $Control/ActionContainer/Action1Button
@onready var action2Button: Button = $Control/ActionContainer/Action2Button
@onready var numMovesLabel: Label = $Control/NumMovesLabel
@onready var currentTurnLabel: Label = $Control/TurnLabelsContainer/CurrentTurnLabel
@onready var futureTurnsLabel: Label = $Control/TurnLabelsContainer/FutureTurnsLabel


func _ready():
    moveButton.button_down.connect(func(): moveActionInitiate.emit())
    nextTurnButton.button_down.connect(func(): nextTurnActionInitiate.emit())
    interactButton.button_down.connect(func(): interactActionInitiate.emit())
    attackButton.button_down.connect(func(): actionInitiate.emit(ActionType.ATTACK))
    action1Button.button_down.connect(func(): actionInitiate.emit(ActionType.ACTION1))
    action2Button.button_down.connect(func(): actionInitiate.emit(ActionType.ACTION2))
    return

func setState(state: State):
    _state = state
    return

func setMoveNum(i: int):
    numMovesLabel.text = str(i)
    return

func showTurns(turns: Array[int]):
    var t = ""
    for turn in turns:
        t += _state.get_entity(turn).display_name + " "
    futureTurnsLabel.text = t
    return

func showCurrentTurn(turn: int):
    var entity := _state.get_entity(turn)
    currentTurnLabel.text = _state.get_entity(turn).display_name
    
    if _state.isAlly(entity):
        action1Button.text = entity.action1.display_name
        action2Button.text = entity.action2.display_name
    
    return

func enableAllButtons():
    moveButton.disabled = false
    nextTurnButton.disabled = false
    interactButton.disabled = false
    attackButton.disabled = false    
    action1Button.disabled = false
    action2Button.disabled = false
    return

func disableAllButtons():
    nextTurnButton.disabled = true
    interactButton.disabled = true
    disableActionButtons()
    disableMovesButton()
    return

func disableMovesButton():
    moveButton.disabled = true
    return

func disableActionButtons():
    attackButton.disabled = true
    action1Button.disabled = true
    action2Button.disabled = true
    return
