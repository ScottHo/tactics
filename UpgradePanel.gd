class_name UpgradePanel extends Node2D

@onready var health_c = $GridContainer/Health
@onready var armor_c = $GridContainer/Armor
@onready var movement_c = $GridContainer/Movement
@onready var initiative_c = $GridContainer/Initiative
@onready var attack_c = $GridContainer/Attack
@onready var action1_c = $GridContainer/Special
@onready var action2_c = $GridContainer/Ultimate
@onready var range_c = $GridContainer/Range
@onready var skill_points_label = $Bottom/SkillPointsLabel
@onready var bottom_label = $Bottom/Label
@onready var reset_button = $Bottom/ResetButton
@onready var deploy_button = $Bottom/DeployButton
@onready var entity_sprite = $EntityContainer/Sprite2D
@onready var entity_label = $EntityContainer/Label
@onready var action1_description: SpecialDescriptionPanel = $GridContainer/Special/SpecialPanel
@onready var action2_description: SpecialDescriptionPanel = $GridContainer/Ultimate/SpecialPanel

var containers = []

# Modification and max values
var health_mod: int
var armor_mod: int
var movement_mod: int
var initiative_mod: int
var attack_mod: int
var special1_mod: int
var special2_mod: int
var range_mod: int
var health_max := 10
var armor_max := 2
var movement_max := 2
var movement_max_melee := 4
var initiative_max := 3
var attack_max := 3
var special1_max := 4
var special2_max := 1
var range_max := 2
var skill_points_base := 0
var deploy_full := false

var _entity: Entity
var action1_copy: Action
var action2_copy: Action

signal deployed

func _ready():
    containers = [
        health_c,
        armor_c,
        movement_c,
        initiative_c,
        attack_c,
        action1_c,
        action2_c,
        range_c
    ]
    set_button_signals()
    reset()
    return

func set_button_signals():
    for container in containers:
        button(container).pressed.connect(func():
            skill_point_added(container))
        if container == action1_c:
            description_hover_signal(button(container), action1_description)
        elif container == action2_c:
            description_hover_signal(button(container), action2_description)
        else:
            description_hover_signal(button(container), stat_hover_panel(container))
        stat_hover_panel(container).visible = false

    stat_hover_panel(health_c).show_health() 
    stat_hover_panel(armor_c).show_armor()
    stat_hover_panel(movement_c).show_movement()
    stat_hover_panel(initiative_c).show_initiative()
    stat_hover_panel(attack_c).show_damage()
    stat_hover_panel(range_c).show_range()
    
    reset_button.pressed.connect(redo)
    deploy_button.pressed.connect(deploy)
    return

func description_hover_signal(b: Button, d: Node2D):
    b.mouse_entered.connect(func():
        if reset_button.disabled:
            return
        d.visible = true)
    b.mouse_exited.connect(func():
        d.visible = false)
    return

func start(entity: Entity):
    _entity = entity
    reset()
    setup_entity()
    return
        
func button(container) -> Button:
    return container.get_child(0)

func progress(container) -> TextureProgressBar:
    return container.get_child(1)

func anim(container) -> Sprite2D:
    return container.get_child(2)

func statLabel(container) -> Label:
    return container.get_child(3)

func modifierLabel(container) -> Label:
    return container.get_child(4)

func maxedLabel(container) -> Label:
    return container.get_child(5)

func stat_hover_panel(container) -> Node2D:
    return container.get_child(6)

func skill_point_added(container):
    var _progress = progress(container) 
    _progress.value += 1
    var new_skill_points = int(skill_points_label.text) - 1
    skill_points_label.text = str(new_skill_points)
    if new_skill_points == 0:
        disable_all_stat_buttons()

    if _progress.value == _progress.max_value:
        var prev_scale = anim(container).scale
        anim(container).scale = prev_scale*.85
        anim(container).modulate.a = 1
        progress(container).value = 0
        update_mods(container)
        var tween = get_tree().create_tween()
        tween.tween_property(anim(container), "scale", prev_scale, .2)
        tween.tween_property(anim(container), "modulate:a", 0, .5) 
        tween.play()

    update_to_global(container)
    return

func update_mods(container):
    match container:
        health_c:
            health_mod += 1
            if health_mod == 0:
                modifierLabel(container).text = ""
            else:
                modifierLabel(container).text = "(+%d)" % health_mod
            modifierLabel(container).add_theme_color_override("font_color", Color.GOLD)
            if health_mod == health_max:
                maxedLabel(container).visible = true
                button(container).disabled = true
        armor_c:
            armor_mod += 1
            if armor_mod == 0:
                modifierLabel(container).text = ""
            else:
                modifierLabel(container).text = "(+%d)" % armor_mod
                modifierLabel(container).add_theme_color_override("font_color", Color.GOLD)
            if armor_mod == armor_max:
                maxedLabel(container).visible = true
                button(container).disabled = true
        movement_c:
            movement_mod += 1
            if movement_mod == 0:
                modifierLabel(container).text = ""
            else:
                modifierLabel(container).text = "(+%d)" % movement_mod
                modifierLabel(container).add_theme_color_override("font_color", Color.GOLD)
            if _entity.range == 1:
                if movement_mod == movement_max:
                    maxedLabel(container).visible = true
                    button(container).disabled = true
            else:
                if movement_mod == movement_max_melee:
                    maxedLabel(container).visible = true
                    button(container).disabled = true
        initiative_c:
            initiative_mod += 1
            if initiative_mod == 0:
                modifierLabel(container).text = ""
            else:
                modifierLabel(container).text = "(+%d)" % initiative_mod
                modifierLabel(container).add_theme_color_override("font_color", Color.GOLD)
            if initiative_mod == initiative_max:
                maxedLabel(container).visible = true
                button(container).disabled = true
        attack_c:
            attack_mod += 1
            if attack_mod == 0:
                modifierLabel(container).text = ""
            else:
                modifierLabel(container).text = "(+%d)" % attack_mod
                modifierLabel(container).add_theme_color_override("font_color", Color.GOLD)
            if attack_mod == attack_max:
                maxedLabel(container).visible = true
                button(container).disabled = true
        action1_c:
            special1_mod += 1
            modifierLabel(container).text = str(special1_mod)
            if special1_mod > 1:
                modifierLabel(container).add_theme_color_override("font_color", Color.GOLD)
            if special1_mod == special1_max:
                maxedLabel(container).visible = true
                button(container).disabled = true
            update_action_descriptions()
        action2_c:
            special2_mod += 1
            modifierLabel(container).text = str(special2_mod)
            if special2_mod > 1:
                modifierLabel(container).add_theme_color_override("font_color", Color.GOLD)
            if special2_mod == special2_max:
                maxedLabel(container).visible = true
                button(container).disabled = true
            update_action_descriptions()
        range_c:
            range_mod += 1
            if range_mod == 0:
                modifierLabel(container).text = ""
            else:
                modifierLabel(container).text = "(+%d)" % range_mod
            modifierLabel(container).add_theme_color_override("font_color", Color.GOLD)
            if range_mod == range_max:
                maxedLabel(container).visible = true
                button(container).disabled = true
    return

func update_to_global(container):
    var key = _entity.display_name
    var points_data: SkillPointData = Globals.entity_skill_point_distributions[key]
    points_data.total += 1
    match container:
        health_c:
            points_data.health_level = health_mod
            points_data.health_points = progress(container).value
        armor_c:
            points_data.armor_level = armor_mod
            points_data.armor_points = progress(container).value
        movement_c:
            points_data.movement_level = movement_mod
            points_data.movement_points = progress(container).value
        initiative_c:
            points_data.initiative_level = initiative_mod
            points_data.initiative_points = progress(container).value
        attack_c:
            points_data.attack_level = attack_mod
            points_data.attack_points = progress(container).value
        action1_c:
            points_data.action1_level = special1_mod
            points_data.action1_points = progress(container).value
        action2_c:
            points_data.action2_level = special2_mod
            points_data.action2_points = progress(container).value
        range_c:
            points_data.range_level = range_mod
            points_data.range_points = progress(container).value
    return

func deploy():
    if deploy_button.disabled:
        return
    reset_button.disabled = true
    deploy_button.disabled = true
    _entity.armor_modifier = health_mod
    _entity.armor_modifier = armor_mod
    _entity.movement_modifier = movement_mod
    _entity.initiative_modifier = initiative_mod
    _entity.damage_modifier = attack_mod
    _entity.action1.level = special1_mod
    _entity.action2.level = special2_mod
    _entity.range_modifier = range_mod
    deployed.emit(_entity)
    _entity = null
    reset()
    return

func redo():
    Globals.entity_skill_point_distributions[_entity.display_name] = SkillPointData.new()
    reset()
    setup_entity()
    return

func reset():
    health_mod = 0
    armor_mod = 0
    movement_mod = 0
    initiative_mod = 0
    attack_mod = 0
    special1_mod = 1
    special2_mod = 0
    range_mod = 0
    skill_points_label.text = str(0)
    
    for container in containers:
        progress(container).value = 0
        maxedLabel(container).visible = false
        button(container).disabled = true
        modifierLabel(container).text = ""
        statLabel(container).text = ""
    
    entity_sprite.texture = load(Globals.NO_BOT_ICON_PATH)
    entity_label.text = "NONE"
    reset_button.disabled = true
    deploy_button.disabled = true
    skill_points_label.text = ""
    bottom_label.text = ""
    return

func disable_all_stat_buttons():
    for container in containers:
        button(container).disabled = true
    return

func setup_entity():
    bottom_label.text = "Skill Points:"
    skill_points_label.text = str(skill_points_base)
    statLabel(health_c).text = str(_entity.max_health)
    statLabel(armor_c).text = str(_entity.armor)
    statLabel(movement_c).text = str(_entity.movement)
    statLabel(initiative_c).text = str(_entity.initiative)
    statLabel(attack_c).text = str(_entity.damage)
    statLabel(action1_c).text = _entity.action1.display_name
    statLabel(action2_c).text = _entity.action2.display_name
    modifierLabel(action1_c).text = str(_entity.action1.level)
    modifierLabel(action2_c).text = str(_entity.action2.level)
    print(_entity.action2.level)
    statLabel(range_c).text = str(_entity.range)
    
    action1_copy = _entity.action1.clone()
    action2_copy = _entity.action2.clone()
    update_action_descriptions()

    for container in containers:
        modifierLabel(container).add_theme_color_override("font_color", Color.WHITE)
        button(container).disabled = false
        if container == range_c and _entity.range == 1:
            button(container).disabled = true
        
    entity_sprite.texture = load(_entity.icon_path)
    entity_label.text = _entity.display_name
    reset_button.disabled = false
    if not deploy_full:
        deploy_button.disabled = false
    update_from_global()
    return

func update_from_global():
    var key = _entity.display_name
    if not Globals.entity_skill_point_distributions.has(key):
        Globals.entity_skill_point_distributions[key] = SkillPointData.new()
    var point_data: SkillPointData = Globals.entity_skill_point_distributions[key]
    progress(health_c).value = point_data.health_points
    progress(armor_c).value = point_data.armor_points
    progress(movement_c).value = point_data.movement_points
    progress(initiative_c).value = point_data.initiative_points
    progress(attack_c).value = point_data.attack_points
    progress(action1_c).value = point_data.action1_points
    progress(action2_c).value = point_data.action2_points
    progress(range_c).value = point_data.range_points
    
    # Subtract 1 because update_mods() increases it by 1, but I'm too lazy to fix
    health_mod = point_data.health_level - 1
    armor_mod = point_data.armor_level - 1
    movement_mod = point_data.movement_level - 1
    initiative_mod = point_data.initiative_level - 1
    attack_mod = point_data.attack_level - 1
    special1_mod = point_data.action1_level - 1
    special2_mod = point_data.action2_level - 1
    range_mod = point_data.range_level - 1
    for container in containers:
        update_mods(container)
    var points_left = skill_points_base - point_data.total
    skill_points_label.text = str(points_left)
    if points_left == 0:
        disable_all_stat_buttons()
    return

func update_action_descriptions():
    action1_copy.level = special1_mod
    action2_copy.level = special2_mod
    action1_description.set_action(action1_copy)
    action2_description.set_action(action2_copy)    
    return

func set_deploy_full(full: bool):
    deploy_full = full
    if deploy_full or reset_button.disabled:
        deploy_button.disabled = true
    else:
        deploy_button.disabled = false
    return

