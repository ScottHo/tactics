class_name DialogBox extends Node2D

var callback: Callable = func():
    pass

func _ready():
    $Continue.pressed.connect(cont)
    $Cancel.pressed.connect(end)
    return

func set_title(t):
    $Title.text = t
    return

func set_description(t):
    $Description.text = t
    return

func set_callback(c):
    callback = c
    return

func cont():
    callback.call()
    end()
    return

func start():
    visible = true
    return
    
func end():
    visible = false
    callback = func():
        pass
    return
    


