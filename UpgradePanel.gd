class_name UpgradePanel extends Node2D

@onready var health_c = $GridContainer/Health
@onready var armor_c = $GridContainer/Armor
@onready var movement_c = $GridContainer/Movement
@onready var speed_c = $GridContainer/Speed
@onready var attack_c = $GridContainer/Attack
@onready var action1_c = $GridContainer/Action1
@onready var action2_c = $GridContainer/Action2
@onready var range_c = $GridContainer/Range

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
