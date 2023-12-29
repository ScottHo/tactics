class_name CollectionPanel extends Node2D

@onready var grid = $GridContainer
@onready var entities := []
var page := 1

signal entity_selected

func _ready():
    for i in range(0, 15):
        var c = container(i)
        button(c).toggled.connect(func(t):
            if t: 
                entity_clicked(i))
    return

func button(c) -> Button:
    return c.get_child(0)

func sprite(c) -> Sprite2D:
    return c.get_child(1)

func deployedLabel(c) -> Label:
    return c.get_child(2)

func container(idx: int) -> Control:
    return grid.get_child(idx)

func populate_entities():
    # TODO: Get these from persistent data
    entities = []
    entities.append(EntityFactory.create_brutus())
    entities.append(EntityFactory.create_longshot())
    entities.append(EntityFactory.create_oilee())
    entities.append(EntityFactory.create_nanonano())
    entities.append(EntityFactory.create_electro())
    entities.append(EntityFactory.create_smithy())
    
    for i in range(len(entities)):
        var c = container(i)
        button(c).disabled = false
        button(c).icon = load(entities[i].icon_path)
        print(entities[i].sprite_path)
        deployedLabel(c).visible = false
    
    for i in range(len(entities), 15):
        var c = container(i)
        button(c).disabled = true
        button(c).icon = load("res://Assets/Unknown.png")
        deployedLabel(c).visible = false
    return

func entity_clicked(idx: int):
    for i in range(0, 15):
        if i == idx:
            continue
        var c = container(i)
        button(c).set_pressed(false)
    entity_selected.emit(entities[idx])
    return


