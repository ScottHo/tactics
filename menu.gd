class_name MenuService extends Node2D

var _state: State
var _button_state_cache: Array
signal moveActionInitiate
signal nextTurnActionInitiate
signal interactActionInitiate
signal actionInitiate
@onready var moveButton: Button = $BottomBar/MoveButton
@onready var nextTurnButton: Button = $BottomBar/TurnButton
@onready var interactButton: Button = $BottomBar/InteractButton
@onready var attackButton: Button = $BottomBar/AttackButton
@onready var action1Button: Button = $BottomBar/Action1Button
@onready var action2Button: Button = $BottomBar/Action2Button
@onready var action1Cost: Label = $BottomBar/Action1Cost
@onready var action2Cost: Label = $BottomBar/Action2Cost
@onready var currentEnergy: Label = $CharacterContainer/CurrentEnergy
@onready var numMovesLabel: Label = $CharacterContainer/NumMovesLabel
@onready var currentTurnLabel: Label = $Control/TurnLabelsContainer/CurrentTurnLabel
@onready var futureTurnsLabel: Label = $Control/TurnLabelsContainer/FutureTurnsLabel


func _ready():
    moveButton.button_down.connect(func(): moveActionInitiate.emit())
    nextTurnButton.button_down.connect(func(): nextTurnActionInitiate.emit())
    interactButton.button_down.connect(func(): interactActionInitiate.emit())
    attackButton.button_down.connect(func(): actionInitiate.emit(ActionType.ATTACK))
    action1Button.button_down.connect(func(): actionInitiate.emit(ActionType.ACTION1))
    action2Button.button_down.connect(func(): actionInitiate.emit(ActionType.ACTION2))
    cache_button_states()
    return

func setState(state: State):
    _state = state
    return

func setMoveNum(i: int):
    numMovesLabel.text = str(i)
    return

func updateEnergy(e: int):
    currentEnergy.text = str(e)
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
    disableActionButtons()
    if _state.isAlly(entity):
        currentEnergy.text = str(entity.energy)
        attackButton.disabled = false
        action1Button.text = entity.action1.display_name
        action1Cost.text = str(entity.action1.cost)
        if entity.action1.cost <= entity.energy:
            action1Button.disabled = false
        action2Button.text = entity.action2.display_name
        action2Cost.text = str(entity.action2.cost)
        if entity.action2.cost <= entity.energy:
            action2Button.disabled = false
    return

func enableAllButtons():
    moveButton.disabled = false
    nextTurnButton.disabled = false
    interactButton.disabled = false
    attackButton.disabled = false    
    action1Button.disabled = false
    action2Button.disabled = false
    return

func cache_button_states():
    _button_state_cache = [
        moveButton.disabled,
        nextTurnButton.disabled,
        interactButton.disabled,
        attackButton.disabled,    
        action1Button.disabled,
        action2Button.disabled,
    ]

func restore_button_states():
    moveButton.disabled = _button_state_cache[0]
    nextTurnButton.disabled = _button_state_cache[1]
    interactButton.disabled = _button_state_cache[2]
    attackButton.disabled = _button_state_cache[3]
    action1Button.disabled = _button_state_cache[4]
    action2Button.disabled = _button_state_cache[5]
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

func set_mechanic_text(t):
    $Control/MechanicContainer/MechanicLabel.text = t
    return

func set_description_text(t):
    $Control/DescriptionContainer/DescriptionLabel.text = t
    return

func win():
    disableActionButtons()
    $Control/GameOverLabel.text = "You win!"
    return

func lose():
    disableActionButtons()
    $Control/GameOverLabel.text = "You lose!"
    return
