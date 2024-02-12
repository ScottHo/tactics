class_name DeployPanel extends Node2D

var _entities = [null, null, null, null, null, null]
var ents_deployed := 0
@onready var grid = $GridContainer

signal entity_removed
signal entity_selected

func _ready():
    for i in range(len(_entities)):
        button(container(i)).connect(
            "gui_input",
            func (event : InputEvent):
                if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
                    #if event.double_click:
                    #    if _entities[i].collection_id != Globals.current_recruit:
                    #        remove_entity(_entities[i])
                    
                    #else:
                    #    entity_selected.emit(_entities[i])
                    entity_selected.emit(_entities[i])
                )
    return

func start():
    for c in grid.get_children():
        sprite(c).texture = load(Globals.NO_BOT_ICON_PATH)
        button(c).disabled = true
    if Globals.current_recruit >= 0:
        var e = EntityFactory.create_bot(Globals.current_recruit)
        add_entity(e)
        entity_selected.emit(e)
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

func remove_entity(entity):
    var idx = -1
    for i in len(_entities):
        if entity == _entities[i]:
            idx = i
            break
    _entities[idx] = null
    var c = container(idx)
    tile(c).texture = load("res://Assets/GUI/SingleTileDisabled.png")
    sprite(c).texture = load(Globals.NO_BOT_ICON_PATH)
    button(c).disabled = true
    update_count()
    entity_removed.emit(entity)
    return

func clear():
    for e in _entities:
        if e == null:
            continue
        if e.collection_id == Globals.current_recruit:
            continue
        remove_entity(e)
    return

func is_full() -> bool:
    return not _entities.has(null)

func is_empty() -> bool:
    return _entities.count(null) == len(_entities)

func has_entity(collection_id: int):
    for e in _entities:
        if e == null:
            continue
        if e.collection_id == collection_id:
            return true
    return false

func update_count():
    ents_deployed = abs(_entities.count(null)-6)
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
