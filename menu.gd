class_name MenuService extends Node2D

var _state: State
var _button_state_cache: Array
var _tab_dict: Dictionary = {}
var _action_names: Dictionary = {}
var _action_descriptions: Dictionary = {}
var _action_costs: Dictionary = {}
var force_show_description := false
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

@onready var nameLabel: Label = $CharacterContainer/NameLabel
@onready var movesLabel: Label = $CharacterContainer/MovesLabel
@onready var damageLabel: Label = $CharacterContainer/DamageLabel
@onready var speedLabel: Label = $CharacterContainer/SpeedLabel
@onready var armorLabel: Label = $CharacterContainer/ArmorLabel
@onready var rangeLabel: Label = $CharacterContainer/RangeLabel
@onready var threatLabel: Label = $CharacterContainer/ThreatLabel
@onready var healthBar: TextureProgressBar = $CharacterContainer/HealthBar
@onready var energyBar: TextureProgressBar = $CharacterContainer/EnergyBar

@onready var expandHover: Sprite2D = $TurnsContainer/ExpandHover
@onready var turnSprites: Array = [$TurnsContainer/Turn0, $TurnsContainer/Turn1,
    $TurnsContainer/Turn2, $TurnsContainer/Turn3, $TurnsContainer/Turn4]


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
        
    setup_action_button(attackButton, ActionType.ATTACK)
    setup_action_button(action1Button, ActionType.ACTION1)
    setup_action_button(action2Button, ActionType.ACTION2)
    $TurnsContainer/ExpandReference.mouse_entered.connect(func():
        show_future_turns(true))
    $TurnsContainer/ExpandReference.mouse_exited.connect(func():
        show_future_turns(false))
    cache_button_states()
    _tab_dict = {}
    return

func setup_action_button(button: Button, action_type):
    button.toggled.connect(func(b):
        unpress_all_buttons(button)
        actionInitiate.emit(b, action_type))
    button.mouse_entered.connect(func():
        show_description(true, action_type))
    button.mouse_exited.connect(func():
        show_description(false, action_type))
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
        offset -= 90
        _tab_dict[entity.id] = tab
    
    offset -= 40
    for entity in _state.all_enemies():
        var tab: EntityInfoTab  = load("res://EntityInfoTab.tscn").instantiate()
        tab.update_from_entity(entity, false)
        $EntityTabContainer.add_child(tab)
        tab.position.y -= offset
        offset -= 90
        _tab_dict[entity.id] = tab
    return

func showTurns(turns: Array[int]):
    _setup_turn_sprite(_state.get_entity(turns[0]), turnSprites[0])
    _setup_turn_sprite(_state.get_entity(turns[1]), turnSprites[1])
    _setup_turn_sprite(_state.get_entity(turns[2]), turnSprites[2])
    _setup_turn_sprite(_state.get_entity(turns[3]), turnSprites[3])
    _setup_turn_sprite(_state.get_entity(turns[4]), turnSprites[4])
    return

func _setup_turn_sprite(entity: Entity, sprite: Sprite2D):
    sprite.texture = entity.sprite.texture_resource()
    sprite.scale = entity.sprite.texture_scale()*1.3
    return

func show_future_turns(show):
    #if show:
    #    expandHover.texture = load("res://Assets/expand-button-glow.png")
    #else:
    #    expandHover.texture = load("res://Assets/expand-button.png")
    turnSprites[0].visible = show
    turnSprites[1].visible = show
    turnSprites[2].visible = show
    turnSprites[3].visible = show
    turnSprites[4].visible = show
    return
    
func showCurrentTurn(turn: int):
    var entity := _state.get_entity(turn)
    nameLabel.text = _state.get_entity(turn).display_name
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
        setup_action_descriptions(entity)
        
    updateEntityInfo(entity)

    show_description(false, null)
    $CharacterContainer/CharacterSprite.texture = entity.sprite.texture_resource()
    $CharacterContainer/CharacterSprite.scale = entity.sprite.texture_scale()*3.5
    return

func setup_action_descriptions(entity: Entity):
    _action_names[ActionType.ATTACK] = entity.attack.display_name
    _action_names[ActionType.ACTION1] = entity.action1.display_name
    _action_names[ActionType.ACTION2] = entity.action2.display_name
    _action_descriptions[ActionType.ATTACK] = entity.attack.description
    _action_descriptions[ActionType.ACTION1] = entity.action1.description
    _action_descriptions[ActionType.ACTION2] = entity.action2.description
    _action_costs[ActionType.ATTACK] = entity.attack.cost
    _action_costs[ActionType.ACTION1] = entity.action1.cost
    _action_costs[ActionType.ACTION2] = entity.action2.cost
    return

func updateEntityInfo(entity: Entity):
    healthBar.max_value = entity.max_health
    healthBar.value = entity.health
    energyBar.value = entity.energy
    damageLabel.text = str(entity.get_damage())
    movesLabel.text = str(entity.moves_left)
    speedLabel.text = str(entity.get_speed())
    armorLabel.text = str(entity.get_armor())
    rangeLabel.text = str(entity.get_range())
    threatLabel.text = str(entity.threat)
    if not entity.is_ally:
        threatLabel.text = "-"
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

func win():
    disableActionButtons()
    $GameOverLabel.text = "You win!"
    return

func lose():
    disableActionButtons()
    $GameOverLabel.text = "You lose!"
    return

func show_description(show, action_type):
    if force_show_description:
        show = true
    if not _action_descriptions.has(action_type):
        show = false
    if show:
        $DescriptionContainer/DescriptionName.text = _action_names[action_type]
        $DescriptionContainer/DescriptionLabel.text = _action_descriptions[action_type]
        $DescriptionContainer/DescriptionCost.text = str(_action_costs[action_type])
    $DescriptionContainer.visible = show
    return
