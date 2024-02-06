extends Node2D

func _ready():
    $Control/Control/Button.pressed.connect(func():
        get_tree().change_scene_to_file("res://prologue.tscn")
    )
    $ExitButton.pressed.connect(func():
        get_tree().quit())
    Globals.level_debug_mode = false
    return
