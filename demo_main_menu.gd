extends Node2D

func _ready():
    $Buster/AnimationPlayer.play("Move")
    $Buster/CharacterCommon/InfoBoxContainer.visible = false
    $Label2.visible = false    
    if Globals.current_level > 8:
        $Control/Control/Button.disabled = true
        $Label2.visible = true
    $Control/Control/Button.pressed.connect(func():
        get_tree().change_scene_to_file("res://prologue.tscn")
    )
    $ExitButton.pressed.connect(func():
        get_tree().quit())
    return
