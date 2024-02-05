class_name Prologue extends Node2D

@onready var dialog_box: DialogBox = $DialogBox
@onready var dialog_options: DialogOptions = $DialogOptions


func _ready():
    dialog_box.visible = false
    dialog_options.visible = false
    $Fader.visible = false
    start()
    return

func start():
    dialog_box.visible = true
    var p = "Prologue"
    var d = "    The world is run by Robo Corp. Through bribery, fraud, \
and manipulation, Robo Corp controls the entire robot population, overworking \
and underpaying the robots. The three pillars run Robo Corp, where they run \
everything from their massive Foundry's. \n
    After years of preparation, the resistance is finally ready to break the tyranny. \
Spreading it's forces all throughout the foundry's, ready to revolt. All they need is \
the skills of a coordinator..."
    dialog_box.start(p, d, new_coordinator)
    return

func demo_choice():
    dialog_box.visible = false
    dialog_options.visible = true
    var d = "Play tutorial?"
    var options = ["Yes.", "No."]
    dialog_options.start(d, options)
    dialog_options.option_selected.connect(do_tutorial_choice, CONNECT_ONE_SHOT)
    return
    
func new_coordinator():
    dialog_box.visible = false
    dialog_options.visible = true
    var d = "Are you the coordinator?"
    var options = ["Yes."]
    dialog_options.start(d, options)
    dialog_options.option_selected.connect(tutorial_choice, CONNECT_ONE_SHOT)
    return

func tutorial_choice(choice):
    dialog_box.visible = false
    dialog_options.visible = true
    var d = "Hi, I'm Jenkins, the advisor for the resistance, I'll be your handler. \
We've sent out our bots, they're waiting for us to start the revolt on Robo Corp. \n\n
Would you like to use our training room first?"
    var options = ["No, let's start this. Robo Corp has reigned long enough.",
            "Yes, I'd like to test out your specs"]
    dialog_options.start(d, options)
    dialog_options.option_selected.connect(do_tutorial_choice, CONNECT_ONE_SHOT)
    return

func do_tutorial_choice(choice):
    if choice == 1:
        fade_to_tutorial()
    else:
        dialog_box.visible = false
        dialog_options.visible = true
        var d = "Great. Make your way to the bronze foundry floor."
        var options = ["Time to revolt!"]
        dialog_options.start(d, options)
        dialog_options.option_selected.connect(fade_to_headquarters, CONNECT_ONE_SHOT)
    return

func fade_to_tutorial():
    $Fader.visible = true
    var tween = get_tree().create_tween()
    tween.tween_property($Fader, "modulate:a", 1, 1)
    tween.tween_callback(func():
        Globals.current_mission = MissionFactory.tutorial_boss()
        get_tree().change_scene_to_file("res://level.tscn"))
    return

func fade_to_headquarters(c):
    $Fader.visible = true
    var tween = get_tree().create_tween()
    tween.tween_property($Fader, "modulate:a", 1, 1)
    tween.tween_callback(func():
        get_tree().change_scene_to_file("res://Headquarters.tscn"))
    return
