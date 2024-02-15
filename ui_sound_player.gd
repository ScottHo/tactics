extends Node

func _ready():
    # when _ready is called, there might already be nodes in the tree, so connect all existing buttons
    connect_buttons(get_tree().root)
    get_tree().connect("node_added", _on_SceneTree_node_added)
    $Music.play()
    $Music.finished.connect(func():
        $Music.stream_paused = false
        $Music.play())
    return
    

func _on_SceneTree_node_added(node):
    if node is BaseButton:
        connect_to_button(node)
    return

func _on_Button_pressed():
    $AudioStreamPlayer2D.play()
    return


# recursively connect all buttons
func connect_buttons(root):
    for child in root.get_children():
        if child is BaseButton:
            connect_to_button(child)
        connect_buttons(child)
    return

func connect_to_button(button):
    button.pressed.connect(func():
        $AudioStreamPlayer2D.play())
    button.mouse_entered.connect(func():
        if button.disabled:
            return
        $AudioStreamPlayer2D2.play())
    return
