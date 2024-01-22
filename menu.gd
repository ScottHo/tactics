class_name MenuService extends Node2D

var _state: State
var _button_state_cache: Array
var _tab_dict: Dictionary = {}
var _actions: Dictionary = {}
var force_show_description := false
var _current_interactable: String = ""
var tutorial_mode := false

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
@onready var passiveHover: ReferenceRect = $CharacterContainer/Passive/Label/PassiveHover

@onready var charSprite: Sprite2D = $CharacterContainer/CharacterSprite
@onready var nameLabel: Label = $CharacterContainer/NameLabel
@onready var healthLabel: Label = $CharacterContainer/HealthLabel
@onready var slashLabel: Label = $CharacterContainer/SlashLabel
@onready var maxHealthLabel: Label = $CharacterContainer/MaxHealthLabel
@onready var movesLabel: Label = $CharacterContainer/Stats/Moves/Label
@onready var damageLabel: Label = $CharacterContainer/Stats/Damage/Label
@onready var initiativeLabel: Label = $CharacterContainer/Stats/Initiative/Label
@onready var armorLabel: Label = $CharacterContainer/Stats/Armor/Label
@onready var rangeLabel: Label = $CharacterContainer/Stats/Range/Label
@onready var threatLabel: Label = $CharacterContainer/Stats/Threat/Label
@onready var healthBar: TextureProgressBar = $CharacterContainer/HealthBar
@onready var energyBar: TextureProgressBar = $CharacterContainer/EnergyBar

@onready var showTurnsButton: Button = $TurnsContainer/ShowTurnsButton
@onready var turnSpriteContainer: Control = $TurnsContainer/GridContainer

@onready var descSpecialPanel: SpecialDescriptionPanel = $DescriptionContainer/SpecialPanel
@onready var descShortPanel: Sprite2D = $DescriptionContainer/ShortPanel
@onready var descMoves: Label = $DescriptionContainer/MoveContainer/MovesLeft
@onready var descContainer: Control = $DescriptionContainer
@onready var descMoveInterName: Label = $DescriptionContainer/MoveInteractName
@onready var descInterDesc: Label = $DescriptionContainer/InteractDescription
@onready var descPassivePanel: PassivePanel = $PassivePanel

@onready var mech_1_name_short = $MechanicContainer/Short/Grid/Mechanic/Name
@onready var mech_2_name_short = $MechanicContainer/Short/Grid/Mechanic2/Name
@onready var mech_3_name_short = $MechanicContainer/Short/Grid/Mechanic3/Name
@onready var mech_1_name_tall = $MechanicContainer/Long/Grid/Mechanic/Name
@onready var mech_2_name_tall = $MechanicContainer/Long/Grid/Mechanic2/Name
@onready var mech_3_name_tall = $MechanicContainer/Long/Grid/Mechanic3/Name
@onready var mech_1_description_tall = $MechanicContainer/Long/Grid/Mechanic/Label
@onready var mech_2_description_tall = $MechanicContainer/Long/Grid/Mechanic2/Label
@onready var mech_3_description_tall = $MechanicContainer/Long/Grid/Mechanic3/Label

@onready var scoreService: ScoreService = $"../ScoreService"
@onready var jenkins: Jenkins = $"Jenkins"

func _ready():
    $AbortMissionButton.pressed.connect(lose)

    setup_next_turn_button()
    setup_mechanic_container()
    setup_move_button()
    setup_interact_button()
    setup_action_button(attackButton, ActionType.ATTACK)
    setup_action_button(action1Button, ActionType.ACTION1)
    setup_action_button(action2Button, ActionType.ACTION2)
    setup_passive_hover()
    
    showTurnsButton.toggled.connect(func(b):
        show_future_turns(b))

    $Timer.timeout.connect(finish_menu_animations)

    cache_button_states()
    _tab_dict = {}
    return

func setup_mechanic_container():
    mech_1_name_short.text = ""
    mech_2_name_short.text = ""
    mech_3_name_short.text = ""
    mech_1_name_tall.text = ""
    mech_2_name_tall.text = ""
    mech_3_name_tall.text = ""
    mech_1_description_tall.text = ""
    mech_2_description_tall.text = ""
    mech_3_description_tall.text = ""
    $MechanicContainer/Long.visible = false
    $MechanicContainer/MechReference.mouse_entered.connect(func():
        $MechanicContainer/Long.visible = true
        $MechanicContainer/Short.visible = false)
    $MechanicContainer/MechReference.mouse_exited.connect(func():
        $MechanicContainer/Long.visible = false
        $MechanicContainer/Short.visible = true)
    return
    
func setup_next_turn_button():
    nextTurnButton.button_down.connect(func():
        if Globals.in_action:
            restore_button_states()
            disableTurnButton()
            var t = get_tree().create_timer(.5)
            t.timeout.connect(func():
                enable_turn_button())
            nextTurnButton.text = "Next\nTurn"
            Globals.end_action()
        else:
            disableTurnButton(true)
            unpress_all_buttons()
            nextTurnActionInitiate.emit()
            )
    nextTurnButton.mouse_entered.connect(func():
        control_entered_tasks())
    nextTurnButton.mouse_exited.connect(func():
        control_exited_tasks())

func setup_move_button():
    moveButton.toggled.connect(func(b):
        button_toggled_tasks(moveButton, b)
        moveActionInitiate.emit(b))
    moveButton.mouse_entered.connect(func():
        control_entered_tasks()
        show_description(true, ActionType.MOVE))
    moveButton.mouse_exited.connect(func():
        control_exited_tasks()
        show_description(false, ActionType.MOVE))
    return

func setup_interact_button():
    interactButton.toggled.connect(func(b):
        button_toggled_tasks(interactButton, b)
        interactActionInitiate.emit(b))
    interactButton.mouse_entered.connect(func():
        control_entered_tasks()
        show_description(true, ActionType.INTERACT))
    interactButton.mouse_exited.connect(func():
        control_exited_tasks()
        show_description(false, ActionType.INTERACT))
    return

func setup_action_button(button: Button, action_type):
    button.toggled.connect(func(b):
        button_toggled_tasks(button, b)
        actionInitiate.emit(b, action_type))
    button.mouse_entered.connect(func():
        control_entered_tasks()
        show_description(true, action_type))
    button.mouse_exited.connect(func():
        control_exited_tasks()
        show_description(false, action_type))
    return

func setup_passive_hover():
    descPassivePanel.visible = false
    passiveHover.mouse_entered.connect(func():
        control_entered_tasks()
        if descPassivePanel.has_data:
            descPassivePanel.visible = true
        )
    passiveHover.mouse_exited.connect(func():
        control_exited_tasks()
        descPassivePanel.visible = false)
    return

func button_toggled_tasks(button, toggled):
    if toggled:
        unpress_all_buttons(button)
        Globals.start_action(button == moveButton)
        nextTurnButton.text = "Cancel"
    else:
        nextTurnButton.text = "Next\nTurn"
        Globals.end_action()
    return

func control_entered_tasks():
    Globals.on_ui = true
    return

func control_exited_tasks():
    Globals.on_ui = false
    return

func setState(state: State):
    _state = state
    return

func showTurns(turns: Array[int]):
    for i in range(5):
        _setup_turn_sprite(_state.get_entity(turns[i]), turnSpriteContainer.get_child(i).get_child(0))
    return

func _setup_turn_sprite(entity: Entity, sprite: Sprite2D):
    sprite.texture = load(entity.icon_path)
    sprite.scale = entity.sprite.texture_scale()*.8
    return

func show_future_turns(show):
    turnSpriteContainer.visible = show
    return

func pre_showCurrentTurn(turn: int):
    var entity := _state.get_entity(turn)
    nameLabel.text = entity.display_name
    charSprite.texture = load(entity.icon_path)
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
            enable_moves_button()
        if not entity.is_add:
            enable_interact_button()
        enable_attack_button()
        if entity.action1 != null and entity.action1.cost() <= entity.energy:
            enable_special_button()
        if entity.action2 != null and entity.action2.cost() <= entity.energy:
            if not entity.ultimate_used and entity.action2.level > 0:
                enable_ultimate_button()
        setup_action_descriptions(entity)
    
    start_menu_animations()
    return

func start_menu_animations():
    _button_animations(moveButton)
    _button_animations(interactButton)
    _button_animations(attackButton)
    _button_animations(action1Button)
    _button_animations(action2Button)
    $Timer.start(.5)
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
    enable_turn_button()
    menuAnimationsFinished.emit()
    return

func setup_action_descriptions(entity: Entity):
    _actions[ActionType.ATTACK] = entity.attack
    _actions[ActionType.ACTION1] = entity.action1
    _actions[ActionType.ACTION2] = entity.action2
    return

func updateEntityInfo(entity: Entity):
    healthLabel.text = str(entity.health)
    maxHealthLabel.text = str(entity.get_max_health())
    
    healthBar.max_value = entity.get_max_health()
    healthBar.value = entity.health
    energyBar.value = entity.energy
    damageLabel.text = str(entity.get_damage())
    movesLabel.text = str(entity.get_movement())
    descMoves.text = str(entity.moves_left)
    initiativeLabel.text = str(entity.get_initiative())
    armorLabel.text = str(entity.get_armor())
    rangeLabel.text = str(entity.get_range())
    threatLabel.text = str(entity.threat)
    if entity.interactable != null:
        _current_interactable = entity.interactable.display_name
    if not entity.is_ally:
        threatLabel.text = "-"
    _set_colors(entity)

    if entity.moves_left > 0 and entity.is_ally:
        enable_moves_button()
    descPassivePanel.set_passive(entity.passive)
    return

func _set_colors(entity: Entity):
    Utils.set_label_color(healthLabel, Utils.health_color(entity))
    Utils.set_label_color(movesLabel, Utils.movement_color(entity, false))
    Utils.set_label_color(descMoves, Utils.movement_color(entity, true))
    Utils.set_label_color(damageLabel, Utils.damage_color(entity))
    Utils.set_label_color(rangeLabel, Utils.range_color(entity))
    Utils.set_label_color(initiativeLabel, Utils.initiative_color(entity))
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

func enableAllButtons(force = false):
    unpress_all_buttons()    
    if tutorial_mode:
        if not force:
            return
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

func restore_button_states(force = false):
    unpress_all_buttons()
    if tutorial_mode:
        if not force:
            return
    moveButton.disabled = _button_state_cache[0]
    nextTurnButton.disabled = _button_state_cache[1]
    interactButton.disabled = _button_state_cache[2]
    attackButton.disabled = _button_state_cache[3]
    action1Button.disabled = _button_state_cache[4]
    action2Button.disabled = _button_state_cache[5]
    return

func disableAllButtons(force = false):
    unpress_all_buttons()
    if tutorial_mode:
        if not force:
            return
    disableTurnButton(force)
    disableInteractButton(force)
    disableActionButtons(force)
    disableMovesButton(force)
    return

func disableTurnButton(force = false):
    unpress_all_buttons()
    if tutorial_mode:
        if not force:
            return
    nextTurnButton.disabled = true
    return
    
func enable_turn_button(force = false):
    if tutorial_mode:
        if not force:
            return
    nextTurnButton.disabled = false
    return

func disableInteractButton(force = false):
    unpress_all_buttons()
    if tutorial_mode:
        if not force:
            return
    interactButton.disabled = true
    return

func disableMovesButton(force = false):
    unpress_all_buttons()
    if tutorial_mode:
        if not force:
            return
    moveButton.disabled = true
    return

func enable_moves_button(force: = false):
    if tutorial_mode:
        if not force:
            return
    moveButton.disabled = false
    return

func disableActionButtons(force: = false):
    unpress_all_buttons()    
    if tutorial_mode:
        if not force:
            return
    attackButton.disabled = true
    action1Button.disabled = true
    action2Button.disabled = true
    return

func enable_attack_button(force: = false):
    if tutorial_mode:
        if not force:
            return
    attackButton.disabled = false
    return

func enable_special_button(force: = false):
    if tutorial_mode:
        if not force:
            return
    action1Button.disabled = false
    return

func enable_ultimate_button(force: = false):
    if tutorial_mode:
        if not force:
            return
    action2Button.disabled = false
    return

func enable_interact_button(force: = false):
    if tutorial_mode:
        if not force:
            return
    interactButton.disabled = false
    return

func set_mechanic_text_1(n, t):
    mech_1_name_tall.text = n
    mech_1_name_short.text = n
    mech_1_description_tall.text = t
    return

func set_mechanic_text_2(n, t):
    mech_2_name_tall.text = n
    mech_2_name_short.text = n
    mech_2_description_tall.text = t
    return

func set_mechanic_text_3(n, t):
    mech_3_name_tall.text = n
    mech_3_name_short.text = n
    mech_3_description_tall.text = t
    return

func win():
    disableActionButtons()
    $GameOverLabel.visible = true
    $GameOverLabel.text = "Mission success"
    if not tutorial_mode:
        Globals.current_level += 1
        if Globals.current_recruit != -1:
            Globals.bots_collected.append(Globals.current_recruit)
            var n = EntityFactory.create_bot(Globals.current_recruit).display_name
            $RecruitLabel.visible = true
            $RecruitLabel.text = "New Recruit!\n" + n
            Globals.current_recruit = -1
    scoreService.show_score()
    Globals.skill_points += scoreService.calc_points()
    Globals.missions_found = false
    Globals.mission_options = []
    Globals.recruit_options = []
    return

func lose():
    disableActionButtons()
    $GameOverLabel.visible = true
    $GameOverLabel.text = "Mission fail"
    scoreService.show_score()
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

func jenkins_talk(t, mood: Jenkins.Mood):
    jenkins.talk(t, mood)
    return
