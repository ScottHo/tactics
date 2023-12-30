class_name UpgradePanel extends Node2D

@onready var health_c = $GridContainer/Health
@onready var armor_c = $GridContainer/Armor
@onready var movement_c = $GridContainer/Movement
@onready var speed_c = $GridContainer/Speed
@onready var attack_c = $GridContainer/Attack
@onready var action1_c = $GridContainer/Action1
@onready var action2_c = $GridContainer/Action2
@onready var range_c = $GridContainer/Range
@onready var skill_points_label = $Bottom/SkillPointsLabel
@onready var bottom_label = $Bottom/Label
@onready var reset_button = $Bottom/ResetButton
@onready var deploy_button = $Bottom/DeployButton
@onready var entity_sprite = $EntityContainer/Sprite2D
@onready var entity_label = $EntityContainer/Label

var containers = []
var health_mod: int
var armor_mod: int
var movement_mod: int
var speed_mod: int
var attack_mod: int
var special1_mod: int
var special2_mod: int
var range_mod: int
var health_max := 10
var armor_max := 2
var movement_max := 2
var movement_max_melee := 4
var speed_max := 3
var attack_max := 3
var special1_max := 5
var special2_max := 5
var range_max := 2
var skill_points_base := 0

var _entity: Entity

signal deployed

func _ready():
    containers = [
        health_c,
        armor_c,
        movement_c,
        speed_c,
        attack_c,
        action1_c,
        action2_c,
        range_c
    ]
    for container in containers:
        button(container).pressed.connect(func():
            skill_point_added(container))
    
    reset_button.pressed.connect(redo)
    deploy_button.pressed.connect(deploy)
    reset()
    return

func set_entity(entity: Entity):
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
    return

func update_mods(container):
    match container:
        health_c:
            health_mod += 1            
            modifierLabel(container).text = "(+%d)" % health_mod
            modifierLabel(container).label_settings.font_color = Color.GOLD
            if health_mod == health_max:
                maxedLabel(container).visible = true
                button(container).disabled = true
        armor_c:
            armor_mod += 1
            modifierLabel(container).text = "(+%d)" % armor_mod
            modifierLabel(container).label_settings.font_color = Color.GOLD
            if armor_mod == armor_max:
                maxedLabel(container).visible = true
                button(container).disabled = true
        movement_c:
            movement_mod += 1
            modifierLabel(container).text = "(+%d)" % movement_mod
            modifierLabel(container).label_settings.font_color = Color.GOLD
            if _entity.range == 1:
                if movement_mod == movement_max:
                    maxedLabel(container).visible = true
                    button(container).disabled = true
            else:
                if movement_mod == movement_max_melee:
                    maxedLabel(container).visible = true
                    button(container).disabled = true
        speed_c:
            speed_mod += 1
            modifierLabel(container).text = "(+%d)" % speed_mod
            modifierLabel(container).label_settings.font_color = Color.GOLD
            if speed_mod == speed_max:
                maxedLabel(container).visible = true
                button(container).disabled = true
        attack_c:
            attack_mod += 1
            modifierLabel(container).text = "(+%d)" % attack_mod
            modifierLabel(container).label_settings.font_color = Color.GOLD
            if attack_mod == attack_max:
                maxedLabel(container).visible = true
                button(container).disabled = true
        action1_c:
            special1_mod += 1
            modifierLabel(container).text = str(special1_mod)
            modifierLabel(container).label_settings.font_color = Color.GOLD
            if special1_mod == special1_max:
                maxedLabel(container).visible = true
                button(container).disabled = true
        action2_c:
            special2_mod += 1
            modifierLabel(container).text = str(special2_mod)
            modifierLabel(container).label_settings.font_color = Color.GOLD
            if special2_mod == special2_max:
                maxedLabel(container).visible = true
                button(container).disabled = true
        range_c:
            range_mod += 1
            modifierLabel(container).text = "(+%d)" % range_mod
            modifierLabel(container).label_settings.font_color = Color.GOLD
            if range_mod == range_max:
                maxedLabel(container).visible = true
                button(container).disabled = true
    return

func deploy():
    if deploy_button.disabled:
        return
    reset_button.disabled = true
    deploy_button.disabled = true
    _entity.armor_modifier = health_mod
    _entity.armor_modifier = armor_mod
    _entity.movement_modifier = movement_mod
    _entity.speed_modifier += speed_mod
    _entity.damage_modifier += attack_mod
    _entity.action1.level += special1_mod
    _entity.action2.level += special2_mod
    _entity.range_modifier = range_mod
    deployed.emit(_entity)
    _entity = null
    reset()
    return

func redo():
    reset()
    setup_entity()
    return

func reset():
    health_mod = 0
    armor_mod = 0
    movement_mod = 0
    speed_mod = 0
    attack_mod = 0
    special1_mod = 1
    special2_mod = 1
    range_mod = 0
    skill_points_label.text = str(0)
    
    for container in containers:
        progress(container).value = 0
        maxedLabel(container).visible = false
        button(container).disabled = true
        modifierLabel(container).text = ""
        statLabel(container).text = ""
    
    entity_sprite.texture = load(Globals.NO_BOT_ICON_PATH)
    entity_label.text = "NONE SELECTED"
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
    statLabel(speed_c).text = str(_entity.speed)
    statLabel(attack_c).text = str(_entity.damage)
    modifierLabel(action1_c).text = str(_entity.action1.level)
    modifierLabel(action2_c).text = str(_entity.action2.level)
    statLabel(range_c).text = str(_entity.range)
    
    for container in containers:
        modifierLabel(container).label_settings.font_color = Color.WHITE
        button(container).disabled = false
        if container == range_c and _entity.range == 1:
            button(container).disabled = true
        if container == action1_c or container == action2_c:
            statLabel(container).text = "Level"
        
    entity_sprite.texture = load(_entity.icon_path)
    entity_label.text = _entity.display_name
    reset_button.disabled = false
    deploy_button.disabled = false
    return

