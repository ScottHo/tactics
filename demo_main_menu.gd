extends Node2D

func _ready():
    $Buster/AnimationPlayer.play("Move")
    $Label2.visible = false    
    if Globals.current_level > 8:
        $Control/Control/Button.disabled = true
        $Label2.visible = true
    $Control/Control/Button.pressed.connect(func():
        get_tree().change_scene_to_file("res://Headquarters.tscn")
    )
    $ExitButton.pressed.connect(func():
        get_tree().quit())
    if len(Globals.bots_collected) == 0:
        var b = EntityFactory.Bot.values()
        b.shuffle()
        Globals.bots_collected = b.slice(0, 6)
    return
