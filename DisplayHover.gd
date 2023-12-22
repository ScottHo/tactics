extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
    var r : ReferenceRect = $".."
    r.mouse_entered.connect(show_tooltip)
    r.mouse_exited.connect(hide_tooltip)
    return


func show_tooltip():
    print("SHOW")
    visible = true
    return

func hide_tooltip():
    print("HIDE")
    visible = false
    return
