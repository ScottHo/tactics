class_name MenuService extends Node2D

var _state: State
var _button_state_cache: Array
var _tab_dict: Dictionary = {}
var _actions: Dictionary = {}
var force_show_description := false
var _current_interactable: String = ""

signal moveActionInitiate
signal nextTurnActionInitiate
signal interactActionInitiate
signal actionInitiate
signal menuAnimationsFinished

@onready var nextTurnButton: Button = $TurnButton

@onready var moveButton: Button = $CharacterContainer/MoveButton
@onready var interactButton: Button = $CharacterContainer/InteractButton
@onready var attackButton: Button = $CharacterContainer/AttackButton
@onready var action1Button: Button = $CharacterContainer/Action1Button
@onready var action2Button: Button = $CharacterContainer/Action2Button

@onready var charSprite: Sprite2D = $CharacterContainer/CharacterSprite
@onready var nameLabel: Label = $CharacterContainer/NameLabel
@onready var healthLabel: Label = $CharacterContainer/HealthLabel
@onready var slashLabel: Label = $CharacterContainer/SlashLabel
@onready var maxHealthLabel: Label = $CharacterContainer/MaxHealthLabel
@onready var movesLabel: Label = $CharacterContainer/Stats/Moves/Label
@onready var damageLabel: Label = $CharacterContainer/Stats/Damage/Label
@onready var speedLabel: Label = $CharacterContainer/Stats/Speed/Label
@onready var armorLabel: Label = $CharacterContainer/Stats/Armor/Label
@onready var rangeLabel: Label = $CharacterContainer/Stats/Range/Label
@onready var threatLabel: Label = $CharacterContainer/Stats/Threat/Label
@onready var healthBar: TextureProgressBar = $CharacterContainer/HealthBar
@onready var energyBar: TextureProgressBar = $CharacterContainer/EnergyBar

@onready var expandHover: Sprite2D = $TurnsContainer/ExpandHover
@onready var turnSprites: Array = [$TurnsContainer/Turn0, $TurnsContainer/Turn1,
    $TurnsContainer/Turn2, $TurnsContainer/Turn3, $TurnsContainer/Turn4,
    $TurnsContainer/Turn5, $TurnsContainer/Turn6, $TurnsContainer/Turn7,
    $TurnsContainer/Turn8, $TurnsContainer/Turn9]

@onready var descSpecialPanel: SpecialDescriptionPanel = $DescriptionContainer/SpecialPanel
@onready var descShortPanel: Sprite2D = $DescriptionContainer/ShortPanel
@onready var descMoves: Label = $DescriptionContainer/MoveContainer/MovesLeft
@onready var descInter: Label = $DescriptionContainer/InteractMessage
@onready var descContainer: Control = $DescriptionContainer
@onready var descMoveInterName: Label = $DescriptionContainer/MoveInteractName
@onready var descInterDesc: Label = $DescriptionContainer/InteractDescription


func _ready():
    nextTurnButton.button_down.connect(func():
        unpress_all_buttons()
        nextTurnActionInitiate.emit())

    setup_move_button()
    setup_interact_button()
    setup_action_button(attackButton, ActionType.ATTACK)
    setup_action_button(action1Button, ActionType.ACTION1)
    setup_action_button(action2Button, ActionType.ACTION2)

    $TurnsContainer/ExpandReference.mouse_entered.connect(func():
        show_future_turns(true))
    $TurnsContainer/ExpandReference.mouse_exited.connect(func():
        show_future_turns(false))

    $Timer.timeout.connect(finish_menu_animations)

    cache_button_states()
    _tab_dict = {}
    return

func setup_move_button():
    moveButton.toggled.connect(func(b):
        unpress_all_buttons(moveButton)
        moveActionInitiate.emit(b))
    moveButton.mouse_entered.connect(func():
        show_description(true, ActionType.MOVE))
    moveButton.mouse_exited.connect(func():
        show_description(false, ActionType.MOVE))
    return

func setup_interact_button():
    interactButton.toggled.connect(func(b):
        unpress_all_buttons(interactButton)
        interactActionInitiate.emit(b))
    interactButton.mouse_entered.connect(func():
        show_description(true, ActionType.INTERACT))
    interactButton.mouse_exited.connect(func():
        show_description(false, ActionType.INTERACT))
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

func showTurns(turns: Array[int]):
    for i in range(10):
        _setup_turn_sprite(_state.get_entity(turns[i]), turnSprites[i])
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
    for i in range(10):
        turnSprites[i].visible = show
    return

func pre_showCurrentTurn(turn: int):
    var entity := _state.get_entity(turn)
    nameLabel.text = entity.display_name
    charSprite.texture = entity.sprite.texture_resource()
    charSprite.scale = entity.sprite.texture_scale()*2.8
    charSprite.modulate.a = 0
    show_description(false, null)
    updateEntityInfo(entity)
    disableAllButtons()
    var ap: AnimationPlayer = charSprite.get_child(0)
    ap.current_animation = "fade_in"
    ap.play()
    return
    
func showCurrentTurn(turn: int):
    var entity := _state.get_entity(turn)
    var is_ally := entity.is_ally
    if is_ally:
        if entity.get_movement() > 0:
            moveButton.disabled = false
        interactButton.disabled = false
        attackButton.disabled = false
        if entity.action1.cost() <= entity.energy:
            action1Button.disabled = false
        if entity.action2.cost() <= entity.energy:
            action2Button.disabled = false
        setup_action_descriptions(entity)
    
    start_menu_animations()
    return

func start_menu_animations():
    _button_animations(moveButton)
    _button_animations(interactButton)
    _button_animations(attackButton)
    _button_animations(action1Button)
    _button_animations(action2Button)
    $Timer.start(1)
    return

func _button_animations(button: Button):
    if button.disabled:
        return
    var ap: AnimationPlayer = button.get_child(0)
    ap.current_animation = "grow"
    ap.play()
    return

func finish_menu_animations():
    $Timer.stop()
    nextTurnButton.disabled = false    
    menuAnimationsFinished.emit()
    return

func setup_action_descriptions(entity: Entity):
    _actions[ActionType.ATTACK] = entity.attack
    _actions[ActionType.ACTION1] = entity.action1
    _actions[ActionType.ACTION2] = entity.action2
    return

func updateEntityInfo(entity: Entity):
    healthLabel.text = str(entity.health)
    healthLabel.reset_size()
    slashLabel.reset_size()
    maxHealthLabel.reset_size()
    var healthLabel_x = healthLabel.size.x
    maxHealthLabel.position = healthLabel.position + Vector2(healthLabel_x+16, 0)
    slashLabel.position = healthLabel.position + Vector2(healthLabel_x+1, 0)
    maxHealthLabel.text = str(entity.get_max_health())
    
    healthBar.max_value = entity.get_max_health()
    healthBar.value = entity.health
    energyBar.value = entity.energy
    damageLabel.text = str(entity.get_damage())
    movesLabel.text = str(entity.get_movement())
    descMoves.text = str(entity.moves_left)
    speedLabel.text = str(entity.get_speed())
    armorLabel.text = str(entity.get_armor())
    rangeLabel.text = str(entity.get_range())
    threatLabel.text = str(entity.threat)
    if entity.interactable != null:
        _current_interactable = entity.interactable.display_name
    if not entity.is_ally:
        threatLabel.text = "-"
    _set_colors(entity)
    return

func _set_colors(entity: Entity):
    Utils.set_label_color(healthLabel, Utils.health_color(entity))
    Utils.set_label_color(movesLabel, Utils.movement_color(entity, false))
    Utils.set_label_color(descMoves, Utils.movement_color(entity, true))
    Utils.set_label_color(damageLabel, Utils.damage_color(entity))
    Utils.set_label_color(rangeLabel, Utils.range_color(entity))
    Utils.set_label_color(speedLabel, Utils.speed_color(entity))
    Utils.set_label_color(armorLabel, Utils.armor_color(entity))
    Utils.set_label_color(threatLabel, Utils.threat_color(entity))
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
    disableTurnButton()
    disableInteractButton()
    disableActionButtons()
    disableMovesButton()
    return

func disableTurnButton():
    nextTurnButton.disabled = true
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
    $Timer2.timeout.connect(func():
        get_tree().change_scene_to_file("res://demo_main_menu.tscn")
        )
    $Timer2.start(2)
    Globals.levels_complete += 1
    Globals.skill_points += 5
    var tween = get_tree().create_tween()
    tween.tween_property($Fader, "color:a", 1, 2)
    return

func lose():
    disableActionButtons()
    $GameOverLabel.text = "You lose!"
    $Timer2.timeout.connect(func():
        get_tree().change_scene_to_file("res://demo_main_menu.tscn")
        )
    $Timer2.start(2)
    var c: ColorRect = $Fader
    var tween = get_tree().create_tween()
    tween.tween_property($Fader, "color:a", 1, 2)
    return

func show_description_click(action_type):
    force_show_description = false
    show_description(true, action_type)    
    force_show_description = true
    return

func show_description(show, action_type):
    if force_show_description:
        $DescriptionContainer.visible = true
        return
    if not show:
        $DescriptionContainer.visible = false
        return
    descInterDesc.visible = false
    descMoveInterName.visible = false
    descInter.visible = false
    descSpecialPanel.visible = false
    descShortPanel.visible = false
    descMoves.get_parent().visible = false
    if not _actions.has(action_type):
        descShortPanel.visible = true
        if action_type == ActionType.MOVE:
            descMoveInterName.visible = true
            descMoves.get_parent().visible = true
            descInterDesc.visible = true
            descMoveInterName.text = "Move"
            descInterDesc.text = "Moves are not depleted upon using other actions"
        elif action_type == ActionType.INTERACT:
            descMoveInterName.visible = true
            descInterDesc.visible = true
            descInter.visible = true            
            descMoveInterName.text = "Interact"
            if _current_interactable == "":
                descInterDesc.text = "Interact with or pick up a field object"
            else:
                descInterDesc.text = "Drop the [" + _current_interactable + "] on the tile"
        else:
            show = false
    else:
        descSpecialPanel.visible = true
        descSpecialPanel.set_action(_actions[action_type])
    $DescriptionContainer.visible = show
    return
