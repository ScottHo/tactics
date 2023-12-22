class_name InteractService extends Node2D

var _state: State
var _enabled: bool = false
var _entity: Entity
var _action_type: int = -1
var _target: Vector2i
var _map_bfs: MapBFS

@onready var tileMap: MainTileMap = $"../TileMap"
@onready var highlightMap: HighlightMap = $"../HighlightMap"

signal interactDone

func _ready():
    return

func _input(event):
    if not _enabled:
        return
    if event is InputEventMouseMotion:
        var coords: Vector2i = tileMap.globalToPoint(get_global_mouse_position())
        if _target != coords:
            clearTargetHighlights()
            _target = coords            
            if not _map_bfs.inRange(_target):
                return
            fillTargetHighlights()
    if event is InputEventMouseButton and event.is_pressed():
        match event.button_index:
            MOUSE_BUTTON_LEFT:
                print(_target)
                var _inter: Interactable = _state.interactable_on_tile(_target)
                if _inter == null:
                    print("Could not find interactable")
                    return
                if _entity.interactable != null and _inter.storable:
                    print("Already has item")
                    return
                print("Interact with" + _inter.display_name)
                _inter.effect.call(_entity)
                if _inter.storable:
                    print("Stored")
                    _entity.interactable = _inter
                _state.remove_interactable(_inter)
                interactDone.emit()
                finish()
                return
    return

func setState(state: State):
    _state = state
    return

func fillTargetHighlights():
    highlightMap.set_cell(0, _target, 0, Highlights.RED, 0)
    return

func clearTargetHighlights():
    if _map_bfs.inRange(_target):
        highlightMap.set_cell(0, _target, 0, Highlights.PURPLE, 0)
    else:
        highlightMap.set_cell(0, _target, 0, Highlights.EMPTY, 0)
    _target = Vector2i(999,999)
    return

func maxRange() -> int:
    return 1

func finish():
    if _map_bfs != null:
        _map_bfs.resetHighlights(false)
    _enabled = false
    return

func start(entity: Entity):
    _entity = entity
    _map_bfs = MapBFS.new()
    _map_bfs.init(_entity.location, 1, tileMap, highlightMap, Highlights.PURPLE, _state, false, false)
    _map_bfs.resetHighlights(true)
    _enabled = true
    return
