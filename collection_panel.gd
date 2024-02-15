class_name CollectionPanel extends Node2D

@onready var grid = $GridContainer
var entities := []
var page := 1

signal entity_selected

func _ready():
    for i in range(0, grid.get_child_count()):
        var c = container(i)
        button(c).pressed.connect(func():
            entity_clicked(i))
    return

func button(c) -> Button:
    return c.get_child(0)

func sprite(c) -> Sprite2D:
    return c.get_child(1)

func deployedLabel(c) -> Label:
    return c.get_child(2)

func deadLabel(c) -> Label:
    return c.get_child(3)

func container(idx: int) -> Control:
    return grid.get_child(idx)

func start():
    entities = []
    for bot in Globals.bots_collected:
        entities.append(EntityFactory.create_bot(bot))
        
    for i in range(len(entities)):
        var c = container(i)
        button(c).disabled = false
        button(c).icon = load(entities[i].icon_path)
        deployedLabel(c).visible = false
        deadLabel(c).visible = false
        if Globals.bots_dead.has(entities[i].collection_id):
            button(c).disabled = true
            deadLabel(c).visible = true
    
    for i in range(len(entities), grid.get_child_count()):
        var c = container(i)
        button(c).disabled = true
        button(c).icon = load(Globals.UNKNOWN_BOT_ICON_PATH)
        deployedLabel(c).visible = false
        deadLabel(c).visible = false
    return

func entity_clicked(idx: int):
    entity_selected.emit(entities[idx])
    return

func entity_deployed(ent: Entity):
    var c = container(entities.find(ent))
    deployedLabel(c).visible = true
    button(c).disabled = true
    return

func entity_undeployed(ent: Entity):
    var c = container(entities.find(ent))
    deployedLabel(c).visible = false
    button(c).disabled = false
    return
