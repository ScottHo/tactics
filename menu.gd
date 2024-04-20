class_name MenuService extends Node2D

var _state: State
var _button_state_cache: Array
var _tab_dict: Dictionary = {}
var _actions: Dictionary = {}
var force_show_description := false
var _current_interactable: String = ""
var _entity : Entity
var tutorial_mode := false

signal moveActionInitiate
signal nextTurnActionInitiate
signal interactActionInitiate
signal actionInitiate
signal menuAnimationsFinished
signal stopAction

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

@onready var event_container = $EventContainer
@onready var event_title = $EventContainer/Title
@onready var event_description = $EventContainer/Description
@onready var event_big_title = $EventContainer/BigTitle

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
    $EventContainer/EventTimer.timeout.connect(hide_event)

    _tab_dict = {}
    $MechanicContainer.visible = false
    show_description(false, null)
    hide_event()
    jenkins.visible = false
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
            cancel_actions()
        else:
            enable_turn_button(false, true)
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
        if _entity != null and not _entity.is_ally:
            return
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
        if _entity != null and not _entity.is_ally:
            return
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
        if _entity != null and not _entity.is_ally:
            return
        show_description(true, action_type))
    button.mouse_exited.connect(func():
        control_exited_tasks()
        show_description(false, action_type))
    return

func setup_passive_hover():
    descPassivePanel.visible = false
    passiveHover.mouse_entered.connect(func():
        control_entered_tasks()
        if _entity != null and not _entity.is_ally:
            return
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
        disableAllButtons(true)
        enable_turn_button(true, true)
        Globals.start_action(button == moveButton)
        nextTurnButton.text = "Cancel"
    else:
        cancel_actions()
    return

func control_entered_tasks():
    Globals.on_ui = true
    return

func control_exited_tasks():
    Globals.on_ui = false
    return

func cancel_actions():
    if tutorial_mode:
        restore_button_states()
    else:
        update_button_states()
    stopAction.emit()
    Globals.end_action()
    return

func setState(state: State):
    _state = state
    return

func showTurns(turns: Array[int]):
    for i in range(6):
        _setup_turn_sprite(_state.get_entity(turns[i]), turnSpriteContainer.get_child(i).get_child(0))
    return

func _setup_turn_sprite(entity: Entity, sprite: Sprite2D):
    sprite.texture = load(entity.icon_path)
    sprite.scale = entity.sprite.texture_scale()*.8
    return

func show_future_turns(_show):
    turnSpriteContainer.visible = _show
    return

func pre_showCurrentTurn(e: Entity):
    _entity = e
    nameLabel.text = _entity.display_name
    charSprite.texture = load(_entity.icon_path)
    charSprite.modulate.a = 0
    show_description(false, null)
    updateEntityInfo()
    disableAllButtons()
    var ap: AnimationPlayer = charSprite.get_child(0)
    ap.current_animation = "fade_in"
    ap.play()
    return
    
func showCurrentTurn():
    var is_ally := _entity.is_ally
    if is_ally:
        setup_action_descriptions()
        update_button_states()
    start_menu_animations()
    return

func start_menu_animations():
    _button_animations(moveButton)
    _button_animations(interactButton)
    _button_animations(attackButton)
    _button_animations(action1Button)
    _button_animations(action2Button)
    $Timer.start(.2)
    return

func _button_animations(button: Button):
    var ap: AnimationPlayer = button.get_child(0)
    ap.stop()
    ap.current_animation = "grow"
    if button.disabled:
        ap.current_animation = "RESET"
    ap.play()
    return

func finish_menu_animations():
    $Timer.stop()
    enable_turn_button(true)
    menuAnimationsFinished.emit()
    return

func setup_action_descriptions():
    _actions[ActionType.ATTACK] = _entity.attack
    _actions[ActionType.ACTION1] = _entity.action1
    _actions[ActionType.ACTION2] = _entity.action2
    return

func updateEntityInfo():
    healthLabel.text = str(_entity.health)
    maxHealthLabel.text = str(_entity.get_max_health())
    healthBar.max_value = _entity.get_max_health()
    healthBar.value = _entity.health
    energyBar.value = _entity.energy
    damageLabel.text = str(_entity.get_damage())
    movesLabel.text = str(_entity.get_movement())
    descMoves.text = str(_entity.moves_left)
    initiativeLabel.text = str(_entity.get_initiative())
    armorLabel.text = str(_entity.get_armor())
    rangeLabel.text = str(_entity.get_range())
    threatLabel.text = str(_entity.threat)
    if _entity.interactable != null:
        _current_interactable = _entity.interactable.display_name
    if not _entity.is_ally:
        threatLabel.text = "-"
    _set_colors()
    descPassivePanel.set_passive(_entity.passive)
    return

func _set_colors():
    Utils.set_label_color(healthLabel, Utils.health_color(_entity))
    Utils.set_label_color(movesLabel, Utils.movement_color(_entity, false))
    Utils.set_label_color(descMoves, Utils.movement_color(_entity, true))
    Utils.set_label_color(damageLabel, Utils.damage_color(_entity))
    Utils.set_label_color(rangeLabel, Utils.range_color(_entity))
    Utils.set_label_color(initiativeLabel, Utils.initiative_color(_entity))
    Utils.set_label_color(armorLabel, Utils.armor_color(_entity))
    Utils.set_label_color(threatLabel, Utils.threat_color(_entity))
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

func update_button_states():
    if  tutorial_mode:
        return
    unpress_all_buttons()
    nextTurnButton.disabled = false
    nextTurnButton.text = "End\nTurn"
    moveButton.disabled = true
    interactButton.disabled = true
    attackButton.disabled = true
    action1Button.disabled = true
    action2Button.disabled = true
    if not _entity.is_ally:
        nextTurnButton.disabled = true
        return
    if _entity.moves_left > 0:
        enable_moves_button(true)
    if not _entity.is_add:
        enable_interact_button(true)
    if not _entity.action_used:
        enable_attack_button(true)
        if _entity.action1 != null and _entity.action1.cost() <= _entity.energy:
            enable_special_button(true)
        if _entity.action2 != null and _entity.action2.cost() <= _entity.energy:
            if not _entity.ultimate_used and _entity.action2.level > 0:
                enable_ultimate_button(true)
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
    nextTurnButton.text = "End\nTurn"
    if len(_button_state_cache) == 0:
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
    enable_turn_button(false, force)
    enable_moves_button(false, force)    
    enable_interact_button(false, force)
    enable_attack_button(false, force)
    enable_special_button(false, force)
    enable_ultimate_button(false, force)
    return
    
func enable_turn_button(e: bool, force = false):
    if tutorial_mode:
        if not force:
            return
    nextTurnButton.disabled = not e
    return

func enable_moves_button(e: bool, force = false):
    if tutorial_mode:
        if not force:
            return
    moveButton.disabled = not e
    _button_animations(moveButton)
    return

func enable_interact_button(e: bool, force = false):
    if tutorial_mode:
        if not force:
            return
    interactButton.disabled = not e
    _button_animations(interactButton)
    return

func enable_attack_button(e: bool, force = false):
    if tutorial_mode:
        if not force:
            return
    attackButton.disabled = not e
    _button_animations(attackButton)
    return

func enable_special_button(e: bool, force = false):
    if tutorial_mode:
        if not force:
            return
    action1Button.disabled = not e
    _button_animations(action1Button)
    return

func enable_ultimate_button(e: bool, force = false):
    if tutorial_mode:
        if not force:
            return
    action2Button.disabled = not e
    _button_animations(action2Button)
    return

func set_mechanic_text_1(n, t):
    $MechanicContainer.visible = true
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
    disableAllButtons()
    play_mission_text("Mission success!", false)
    if not tutorial_mode:
        Globals.current_level += 1
        if Globals.current_recruit != -1:
            Globals.bots_collected.append(Globals.current_recruit)
            var n = EntityFactory.create_bot(Globals.current_recruit).display_name
            #$RecruitLabel.visible = true
            #$RecruitLabel.text = n + " joined the roster!"
            Globals.current_recruit = -1
        Globals.skill_points += scoreService.calc_points(true)        
    scoreService.show_score(true)
    Globals.missions_found = false
    Globals.mission_options = []
    Globals.recruit_options = []
    return

func lose():
    disableAllButtons(true)
    play_mission_text("Mission Failed...", false)
    scoreService.show_score(false)
    return

func show_description_click(action_type):
    force_show_description = false
    show_description(true, action_type)    
    force_show_description = true
    return

func show_description(_show, action_type):
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
            descInterDesc.text = "Moves can be used before and/or after other actions."
            if tutorial_mode:
                descInterDesc.text += "\n\nMoves do not deplete in the training room."
        elif action_type == ActionType.INTERACT:
            descMoveInterName.visible = true
            descInterDesc.visible = true
            descMoveInterName.text = "Interact"
            if _current_interactable == "":
                descInterDesc.text = "Interact with or pick up a field object."
            else:
                descInterDesc.text = "Drop the [" + _current_interactable + "] on the tile"
        else:
            _show = false
    else:
        descSpecialPanel.visible = true
        descSpecialPanel.set_action(_actions[action_type])
    $DescriptionContainer.visible = _show
    return

func jenkins_talk(t, mood: Jenkins.Mood):
    jenkins.talk(t, mood)
    return

func mission_start():
    play_mission_text("Mission Start!")
    return

func play_mission_text(t: String, hide_after = true):
    $MissionStartLabel.visible = true
    $MissionStartLabel.text = t
    $MissionStartLabel.visible_characters = 0
    var tween = create_tween()
    tween.tween_property($MissionStartLabel, "visible_characters", len(t), .8)
    if hide_after:
        tween.tween_interval(1.4)
        tween.tween_property($MissionStartLabel, "visible", false, 0)
    return
    
func show_event(t: String, d: String):
    event_container.visible = true
    event_title.text = t
    event_description.text = d
    event_big_title.text = ""
    $EventContainer/EventTimer.stop()
    $EventContainer/EventTimer.start(5)
    return

func show_big_event(t: String):
    event_container.visible = true
    event_title.text = ""
    event_description.text = ""
    event_big_title.text = t
    $EventContainer/EventTimer.stop()
    $EventContainer/EventTimer.start(5)
    return

func hide_event():
    event_container.visible = false
    return
