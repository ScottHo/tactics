class_name DeployPanel extends Node2D

var _entities = [null, null, null, null, null, null]
@onready var grid = $GridContainer
@onready var countLabel = $Label

signal entity_removed


func _ready():
    for i in range(len(_entities)):
        button(container(i)).pressed.connect(func():
            remove_entity(i))
    start()
    return
    
func start():
    for c in grid.get_children():
        sprite(c).texture = load(Globals.NO_BOT_ICON_PATH)
        button(c).disabled = true
    return

func add_entity(entity: Entity):
    for i in len(_entities):
        if _entities[i] == null:
            _entities[i] = entity
            var c = container(i)
            sprite(c).texture = load(entity.icon_path)
            button(c).disabled = false
            set_count()
            return 
    return

func remove_entity(idx: int):
    var entity = _entities[idx]
    _entities[idx] = null
    var c = container(idx)
    sprite(c).texture = load(Globals.NO_BOT_ICON_PATH)
    button(c).disabled = true
    set_count()
    entity_removed.emit(entity)
    return

func is_full() -> bool:
    return not _entities.has(null)

func is_empty() -> bool:
    return _entities.count(null) == len(_entities)

func set_count():
    countLabel.text = str(abs(_entities.count(null)-6)) + "/" + str(len(_entities))
    if is_full():
        countLabel.modulate = Color.GREEN
    elif is_empty():
        countLabel.modulate = Color.RED
    else:
        countLabel.modulate = Color.WHITE
    return

func sprite(c) -> Sprite2D:
    return c.get_child(0)

func button(c) -> Button:
    return c.get_child(1)

func container(idx: int) -> Control:
    idx = abs(idx - 5)
    return grid.get_child(idx)
