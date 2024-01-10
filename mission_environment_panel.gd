class_name MissionEnvironmentPanel extends Control

@onready var buff1: Control =  $GridContainer/Buff1
@onready var buff2: Control =  $GridContainer/Buff2
@onready var buff3: Control =  $GridContainer/Buff3

func _ready():
    return
    
func start():
    clear_all()
    return

func clear_all():
    _clear_buff(buff1)
    _clear_buff(buff2)
    _clear_buff(buff3)
    return

func set_buff(inter: Interactable, idx: int):
    if idx == 0:
        _set_buff(inter, buff1)
        return
    if idx == 1:
        _set_buff(inter, buff2)
        return
    if idx == 2:
        _set_buff(inter, buff3)
        return

func _set_buff(inter: Interactable, container: Control):
    container.visible = true
    name_label(container).text = inter.display_name
    description_label(container).text = inter.description
    sprite(container).load_texture(inter.icon_path, inter.color)
    return

func _clear_buff(container: Control):
    container.visible = false
    return
    
func name_label(c) -> Label:
    return c.get_child(0)

func description_label(c) -> Label:
    return c.get_child(1)
    
func sprite(c) -> InteractableSprite:
    return c.get_child(4)
