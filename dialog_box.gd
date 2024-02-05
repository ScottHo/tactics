class_name DialogBox extends Node2D

var callback: Callable = func():
    pass

func _ready():
    $Continue.pressed.connect(cont)
    $Cancel.pressed.connect(end)
    return

func cont():
    callback.call()
    end()
    return

func start(title, description, _callback = null, show_cancel: bool = true):
    if _callback == null:
        _callback = func():
            pass
    $Title.text = title
    $Description.text = description
    callback = _callback
    $Cancel.visible = false
    if show_cancel:
        $Cancel.visible = true
    visible = true
    return
    
func end():
    visible = false
    callback = func():
        pass
    return
    


