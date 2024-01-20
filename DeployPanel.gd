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
    update_count()
    return

func add_entity(entity: Entity):
    for i in len(_entities):
        if _entities[i] == null:
            _entities[i] = entity
            var c = container(i)
            tile(c).texture = load("res://Assets/GUI/SingleTileSelected.png")
            sprite(c).texture = load(entity.icon_path)
            button(c).disabled = false
            update_count()
            return 
    return

func remove_entity(idx: int):
    var entity = _entities[idx]
    _entities[idx] = null
    var c = container(idx)
    tile(c).texture = load("res://Assets/GUI/SingleTileDisabled.png")
    sprite(c).texture = load(Globals.NO_BOT_ICON_PATH)
    button(c).disabled = true
    update_count()
    entity_removed.emit(entity)
    return

func is_full() -> bool:
    return not _entities.has(null)

func is_empty() -> bool:
    return _entities.count(null) == len(_entities)

func update_count():
    countLabel.text = str(abs(_entities.count(null)-6)) + "/" + str(len(_entities))
    if is_full():
        countLabel.modulate = Color.LAWN_GREEN
    elif is_empty():
        countLabel.modulate = Color.DARK_RED
    else:
        countLabel.modulate = Color.CORAL
    return

func tile(c) -> Sprite2D:
    return c.get_child(0)

func sprite(c) -> Sprite2D:
    return c.get_child(1)

func button(c) -> Button:
    return c.get_child(2)

func container(idx: int) -> Control:
    idx = abs(idx - 5)
    return grid.get_child(idx)
