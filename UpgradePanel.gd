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
@onready var reset_button = $Bottom/ResetButton
@onready var deploy_btton = $Bottom/DeployButton

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
var speed_max := 3
var attack_max := 3
var special1_max := 5
var special2_max := 5
var range_max := 2

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
    
    reset_button.pressed.connect(reset)
    deploy_btton.pressed.connect(deploy)
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
            modifierLabel(container).text = "(+ %d )" % health_mod
            modifierLabel(container).label_settings.font_color = Color.GOLD
            if health_mod == health_max:
                maxedLabel(container).visible = true
                button(container).disabled = true
        armor_c:
            armor_mod += 1
            modifierLabel(container).text = "(+ %d )" % armor_mod
            modifierLabel(container).label_settings.font_color = Color.GOLD
            if armor_mod == armor_max:
                maxedLabel(container).visible = true
                button(container).disabled = true
        movement_c:
            movement_mod += 1
            modifierLabel(container).text = "(+ %d )" % movement_mod
            modifierLabel(container).label_settings.font_color = Color.GOLD
            if movement_mod == movement_max:
                maxedLabel(container).visible = true
                button(container).disabled = true
        speed_c:
            speed_mod += 1
            modifierLabel(container).text = "(+ %d )" % speed_mod
            modifierLabel(container).label_settings.font_color = Color.GOLD
            if speed_mod == speed_max:
                maxedLabel(container).visible = true
                button(container).disabled = true
        attack_c:
            attack_mod += 1
            modifierLabel(container).text = "(+ %d )" % attack_mod
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
            modifierLabel(container).text = "(+ %d )" % range_mod
            modifierLabel(container).label_settings.font_color = Color.GOLD
            if range_mod == range_max:
                maxedLabel(container).visible = true
                button(container).disabled = true
    return

func deploy():
    _entity.armor_modifier = health_mod
    _entity.armor_modifier = armor_mod
    _entity.movement_modifier = movement_mod
    _entity.speed_modifier += speed_mod
    _entity.damage_modifier += attack_mod
    _entity.action1.level += special1_mod
    _entity.action2.level += special2_mod
    _entity.range_modifier = range_mod
    reset_button.disabled = true
    deploy_btton.disabled = true
    deployed.emit(_entity)
    _entity = null
    reset()
    return

func reset():
    health_mod = 0
    armor_mod = 0
    movement_mod = 0
    speed_mod = 0
    attack_mod = 0
    special1_mod = 0
    special2_mod = 0
    range_mod = 0
    for container in containers:
        progress(container).value = 0
        maxedLabel(container).visible = false
        button(container).disabled = false
        modifierLabel(container).text = ""
        statLabel(container).text = ""
    if _entity == null:
        skill_points_label.text = str(0)
    else:
        skill_points_label.text = str(_entity.level * 3)
    return

func setup_entity():
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
        
        if container == action1_c or container == action2_c:
            statLabel(container).text = "Level"
    reset_button.disabled = false
    deploy_btton.disabled = false
    return

