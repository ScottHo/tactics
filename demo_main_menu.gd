extends Node2D

func _ready():
    $PlayButton.pressed.connect(func():
        get_tree().change_scene_to_file("res://Menus/prologue.tscn")
    )
    $ExitButton.pressed.connect(func():
        get_tree().quit())
    Globals.level_debug_mode = false
    UiSoundPlayer.play_music("res://Assets/Audio/MainMenu.wav")
    return
