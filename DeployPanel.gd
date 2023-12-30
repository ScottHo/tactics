class_name DeployPanel extends Node2D

var _entities = [null, null, null, null, null, null]
@onready var grid = $GridContainer

signal entity_removed

static var BOT_NONE := "res://Assets/None.png"

func _ready():
    for i in range(len(_entities)):
        button(container(i)).pressed.connect(func():
            remove_entity(i))
    start()
    return
    
func start():
    for c in grid.get_children():
        sprite(c).texture = load(BOT_NONE)
        button(c).disabled = true
    return

func add_entity(entity: Entity):
    for i in len(_entities):
        if _entities[i] == null:
            _entities[i] = entity
            var c = container(i)
            sprite(c).texture = load(entity.icon_path)
            button(c).disabled = false
            return 
    return

func remove_entity(idx: int):
    var entity = _entities[idx]
    _entities[idx] = null
    var c = container(idx)
    sprite(c).texture = load(BOT_NONE)
    button(c).disabled = true
    entity_removed.emit(entity)
    return

func is_full() -> bool:
    return not _entities.has(null)

func sprite(c) -> Sprite2D:
    return c.get_child(0)

func button(c) -> Button:
    return c.get_child(1)

func container(idx: int) -> Control:
    idx = abs(idx - 5)
    return grid.get_child(idx)
