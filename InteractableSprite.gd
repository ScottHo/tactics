class_name InteractableSprite extends Node2D

@onready var hoverPanel: Node2D = $Hover

var inter: Interactable

func _ready():
    var r : ReferenceRect = $ReferenceRect
    r.mouse_entered.connect(show_label)
    r.mouse_exited.connect(hide_label)
    return

func set_inter(i: Interactable):
    inter = i
    $Hover/Name.text = inter.display_name
    $Hover/Description.text = inter.description
    return
    
func show_label():
    if inter != null:
        hoverPanel.visible = true
    return

func hide_label():
    hoverPanel.visible = false
    return

func load_texture(icon_path: String, color: Color):
    $Sprite2D.texture = load(icon_path)
    $Sprite2D.modulate = color
    return
