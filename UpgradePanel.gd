class_name UpgradePanel extends Node2D

@onready var health_c = $GridContainer/Health
@onready var armor_c = $GridContainer/Armor
@onready var movement_c = $GridContainer/Movement
@onready var speed_c = $GridContainer/Speed
@onready var attack_c = $GridContainer/Attack
@onready var action1_c = $GridContainer/Action1
@onready var action2_c = $GridContainer/Action2
@onready var range_c = $GridContainer/Range
@onready var skill_points_label = $SkillPointsLabel

var health_mod: int
var armor_mod: int
var movement_mod: int
var speed_mod: int
var attack_mod: int
var special1_mod: int
var special2_mod: int
var range_mod: int

var _entity: Entity

func _ready():
    var containers = [
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
    return

func set_entity(entity: Entity):
    _entity = entity
    skill_points_label = _entity.level * 2
    return
        
func button(container) -> Button:
    return container.get_child(0)

func progress(container) -> TextureProgressBar:
    return container.get_child(1)

func anim(container) -> Sprite2D:
    return container.get_child(2)


func skill_point_added(container):
    var _progress = progress(container) 
    _progress.value += 1
    if _progress.value == _progress.max_value:
        var prev_scale = anim(container).scale
        anim(container).scale = prev_scale*.85
        anim(container).modulate.a = 1
        progress(container).value = 0
        var tween = get_tree().create_tween()
        tween.tween_property(anim(container), "scale", prev_scale, .2)
        tween.tween_property(anim(container), "modulate:a", 0, .5) 
        tween.play()
    return

func update_mods(container):
    match container:
        health_c:
            health_mod += 1
        armor_c:
            armor_mod += 1
        movement_c:
            movement_mod += 1
        speed_c:
            speed_mod += 1
        attack_c:
            attack_mod += 1
        action1_c:
            special1_mod += 1
        action2_c:
            special2_mod += 1
        range_c:
            range_mod += 1
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

