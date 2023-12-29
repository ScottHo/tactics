class_name InteractableSprite extends Sprite2D

@onready var hoverPanel: Panel = $Panel
@onready var hoverLabel: Label = $Panel/Label

var inter: Interactable

func _ready():
    var r : ReferenceRect = $ReferenceRect
    r.mouse_entered.connect(show_label)
    r.mouse_exited.connect(hide_label)
    return
    
func show_label():
    if inter != null:
        hoverLabel.text = inter.display_name + "\n\n" + inter.description
        hoverLabel.reset_size()
        hoverPanel.size = hoverLabel.size + Vector2(10, 10)
        hoverPanel.visible = true
    pass

func hide_label():
    hoverPanel.visible = false
    return
