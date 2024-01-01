extends Node2D

@onready var sprite1 = $LongShot
@onready var sprite2 = $Boss1
func _ready():
    $Control/Control/Button.disabled = true
    $Control/Control2/Button.disabled = true
    $Control/Control3/Button.disabled = true
    $Label2.visible = false
    
    if Globals.levels_complete == 0:
        $Control/Control/Button.disabled = false
    if Globals.levels_complete == 1:
        $Control/Control2/Button.disabled = false
    if Globals.levels_complete == 2:
        $Control/Control3/Button.disabled = false
    if Globals.levels_complete == 3:
        $Label2.visible = true

    $Control/Control/Button.pressed.connect(func():
        Globals.curent_mission = MissionFactory.mission_1()
        get_tree().change_scene_to_file("res://DeployGui.tscn")
    )
    $Control/Control2/Button.pressed.connect(func():
        Globals.curent_mission = MissionFactory.mission_2()
        get_tree().change_scene_to_file("res://DeployGui.tscn")
    )
    $Control/Control3/Button.pressed.connect(func():
        Globals.curent_mission = MissionFactory.mission_3()
        get_tree().change_scene_to_file("res://DeployGui.tscn")
    )
    $ExitButton.pressed.connect(func():
        get_tree().quit())
    return
    
func _process(delta):
    sprite1.rotate(.01)
    sprite2.rotate(.01)
