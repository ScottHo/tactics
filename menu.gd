class_name MenuService extends Node2D

var _state: State
var _button_state_cache: Array
var _tab_dict: Dictionary = {}
signal moveActionInitiate
signal nextTurnActionInitiate
signal interactActionInitiate
signal actionInitiate
@onready var moveButton: Button = $CharacterContainer/MoveButton
@onready var nextTurnButton: Button = $TurnButton
@onready var interactButton: Button = $CharacterContainer/InteractButton
@onready var attackButton: Button = $CharacterContainer/AttackButton
@onready var action1Button: Button = $CharacterContainer/Action1Button
@onready var action2Button: Button = $CharacterContainer/Action2Button
@onready var currentEnergy: Label = $CharacterContainer/CurrentEnergy
@onready var numMovesLabel: Label = $CharacterContainer/NumMovesLabel
@onready var currentTurnLabel: Label = $CharacterContainer/CurrentTurnLabel
@onready var healthLabel: Label = $CharacterContainer/HealthLabel
@onready var damageLabel: Label = $CharacterContainer/DamageLabel

func _ready():
    nextTurnButton.button_down.connect(func():
        unpress_all_buttons()
        nextTurnActionInitiate.emit())

    moveButton.toggled.connect(func(b):
        unpress_all_buttons(moveButton)
        moveActionInitiate.emit(b)
        )
    interactButton.toggled.connect(func(b):
        unpress_all_buttons(interactButton)
        interactActionInitiate.emit(b))
    attackButton.toggled.connect(func(b):
        unpress_all_buttons(attackButton)
        actionInitiate.emit(b, ActionType.ATTACK))
    action1Button.toggled.connect(func(b):
        unpress_all_buttons(action1Button)
        actionInitiate.emit(b, ActionType.ACTION1))
    action2Button.toggled.connect(func(b):
        unpress_all_buttons(action2Button)
        actionInitiate.emit(b, ActionType.ACTION2))
    cache_button_states()
    _tab_dict = {}
    return

func setState(state: State):
    _state = state
    return

func updateAllEntities():
    if _tab_dict.is_empty():
        _create_entity_tabs()
    else:
        for tab in _tab_dict.values():
            tab.update()
    return

func _create_entity_tabs():
    var offset = 0
    for entity in _state.all_allies():
        var tab: EntityInfoTab  = load("res://EntityInfoTab.tscn").instantiate()
        tab.update_from_entity(entity, true)
        $EntityTabContainer.add_child(tab)
        tab.position.y -= offset
        offset -= 75
        _tab_dict[entity.id] = tab
    
    offset -= 50
    for entity in _state.all_enemies():
        var tab: EntityInfoTab  = load("res://EntityInfoTab.tscn").instantiate()
        tab.update_from_entity(entity, false)
        $EntityTabContainer.add_child(tab)
        tab.position.y -= offset
        offset -= 75
        _tab_dict[entity.id] = tab
    return

func showTurns(turns: Array[int]):
    $TurnLabelsContainer/FutureTurnsLabel5.text = _state.get_entity(turns[0]).display_name
    $TurnLabelsContainer/FutureTurnsLabel4.text = _state.get_entity(turns[1]).display_name
    $TurnLabelsContainer/FutureTurnsLabel3.text = _state.get_entity(turns[2]).display_name
    $TurnLabelsContainer/FutureTurnsLabel2.text = _state.get_entity(turns[3]).display_name
    $TurnLabelsContainer/FutureTurnsLabel.text = _state.get_entity(turns[4]).display_name
    return
    
func showCurrentTurn(turn: int):
    var entity := _state.get_entity(turn)
    currentTurnLabel.text = _state.get_entity(turn).display_name
    disableActionButtons()
    var is_ally := _state.isAlly(entity)
    if is_ally:
        
        attackButton.disabled = false
        #action1Button.text = entity.action1.display_name.replace(" ", "\n")
        if entity.action1.cost <= entity.energy:
            action1Button.disabled = false
        #action2Button.text = entity.action2.display_name.replace(" ", "\n")
        if entity.action2.cost <= entity.energy:
            action2Button.disabled = false
        updateEntityInfo(entity)
    else:
        currentEnergy.text = "-"
        healthLabel.text = str(entity.health)

    show_description(false)
    $CharacterContainer/CharacterSprite.texture = entity.sprite.texture_resource()
    $CharacterContainer/CharacterSprite.scale = entity.sprite.texture_scale()*3.5
    if not _tab_dict.is_empty():
        for tab in _tab_dict.values():
            tab.set_glow(false)
        _tab_dict[entity.id].set_glow(true)
    return

func updateEntityInfo(entity):
    currentEnergy.text = str(entity.energy)        
    healthLabel.text = str(entity.health)
    damageLabel.text = str(entity.get_damage())
    numMovesLabel.text = str(entity.moves_left)
    return

func unpress_all_buttons(omit=null):
    if omit != moveButton:
        moveButton.set_pressed(false)
    if omit != interactButton:
        interactButton.set_pressed(false)
    if omit != attackButton:
        attackButton.set_pressed(false)    
    if omit != action1Button:
        action1Button.set_pressed(false)
    if omit != action2Button:
        action2Button.set_pressed(false)
    return

func enableAllButtons():
    unpress_all_buttons()
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
    return

func restore_button_states():
    unpress_all_buttons()
    moveButton.disabled = _button_state_cache[0]
    nextTurnButton.disabled = _button_state_cache[1]
    interactButton.disabled = _button_state_cache[2]
    attackButton.disabled = _button_state_cache[3]
    action1Button.disabled = _button_state_cache[4]
    action2Button.disabled = _button_state_cache[5]
    return

func disableAllButtons():
    unpress_all_buttons()
    nextTurnButton.disabled = true
    disableInteractButton()
    disableActionButtons()
    disableMovesButton()
    return

func disableInteractButton():
    interactButton.disabled = true
    return

func disableMovesButton():
    unpress_all_buttons()
    moveButton.disabled = true
    return

func disableActionButtons():
    unpress_all_buttons()
    attackButton.disabled = true
    action1Button.disabled = true
    action2Button.disabled = true
    return

func set_mechanic_text(t):
    $MechanicContainer/MechanicLabel.text = t
    return

func set_description_text(t):
    $DescriptionContainer/DescriptionLabel.text = t
    return

func win():
    disableActionButtons()
    $GameOverLabel.text = "You win!"
    return

func lose():
    disableActionButtons()
    $GameOverLabel.text = "You lose!"
    return

func show_description(show):
    $DescriptionContainer.visible = show
    return
