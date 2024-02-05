class_name DialogOptions extends Node2D

signal option_selected

func _ready():
    $GridContainer/Control/Button.pressed.connect(func():
        option_selected.emit(0))
    $GridContainer/Control2/Button.pressed.connect(func():
        option_selected.emit(1))
    $GridContainer/Control3/Button.pressed.connect(func():
        option_selected.emit(2))
    return

func start(dialog: String, options: Array, mood=Jenkins.Mood.NORMAL):
    var jenkins: Jenkins = $Jenkins
    jenkins.talk(dialog, mood, true)
    $GridContainer/Control.visible = false
    $GridContainer/Control2.visible = false
    $GridContainer/Control3.visible = false
    if len(options) > 0:
        $GridContainer/Control.visible = true
        $GridContainer/Control/Label.text = options[0]
    if len(options) > 1:
        $GridContainer/Control2.visible = true
        $GridContainer/Control2/Label.text = options[1]
    if len(options) > 2:
        $GridContainer/Control3.visible = true
        $GridContainer/Control3/Label.text = options[2]
    return
