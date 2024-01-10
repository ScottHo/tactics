extends Node2D

@onready var sprite1 = $LongShot
@onready var sprite2 = $Boss1
func _ready():
    $Label2.visible = false    
    if Globals.current_level == 13:
        $Control/Control/Button.disabled = true
        $Label2.visible = true
    $Control/Control/Button.pressed.connect(func():
        get_tree().change_scene_to_file("res://room_chooser.tscn")
    )
    $ExitButton.pressed.connect(func():
        get_tree().quit())
    if len(Globals.bots_collected) == 0:
        var b = EntityFactory.Bot.values()
        b.shuffle()
        Globals.bots_collected = b.slice(0, 6)
    return
    
func _process(delta):
    sprite1.rotate(.01)
    sprite2.rotate(.01)
    return
