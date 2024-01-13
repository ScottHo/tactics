class_name Checkpoints extends Node2D


var flashing: Sprite2D
var flash_speed := .5
var flash_speed_x2 := 1.0
var total_delta := 0.0
var pre_loaded_texture
var pre_loaded_highlight

func _ready():
    var level = Globals.current_level
    var checkPoints = [$Start]
    for i in range(1,5):
        checkPoints.append($BronzeFoundry.get_child(i))
    for i in range(1,5):
        checkPoints.append($IronFoundry.get_child(i))
    for i in range(1,5):
        checkPoints.append($SteelFoundry.get_child(i))
    for i in range(1,5):
        checkPoints.append($PlatinumFoundry.get_child(i))
    checkPoints.append($Final)
    for i in range(level):
        checkPoints[i].texture = load("res://Assets/Foundrys/checkpoint_highlight.png")
    
    pre_loaded_texture = preload("res://Assets/Foundrys/checkpoint.png")
    pre_loaded_highlight = preload("res://Assets/Foundrys/checkpoint_highlight.png")
    flashing = checkPoints[level]
    return

func _process(delta):
    total_delta += delta
    if total_delta < flash_speed:
        return
    if total_delta < flash_speed_x2:
        flashing.texture = pre_loaded_highlight
        return
    total_delta = 0
    flashing.texture = pre_loaded_texture
    return
        
