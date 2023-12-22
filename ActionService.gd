class_name ActionService extends Node2D

var _state: State
var _enabled: bool = false
var _entity: Entity
var _action_type: int = -1
var _previous_coords: Vector2i
var _target_points: Array = []
var _map_bfs: MapBFS

@onready var tileMap: MainTileMap = $"../TileMap"
@onready var highlightMap: HighlightMap = $"../HighlightMap"

signal actionDone

func _ready():
    return

func _input(event):
    if not _enabled:
        return
    if event is InputEventMouseMotion:
        var coords: Vector2i = tileMap.globalToPoint(get_global_mouse_position())
        if _previous_coords != coords:
            clearTargetHighlights()
            _previous_coords = coords            
            if not _map_bfs.inRange(coords, action().self_castable):
                return
            _target_points = VectorHelpers.get_target_coords(_entity.location, coords, shape())
            fillTargetHighlights()
    if event is InputEventMouseButton and event.is_pressed():
        match event.button_index:
            MOUSE_BUTTON_LEFT:
                if len(_target_points) <= 0:
                    return
                ActionCommon.do_action(_state, _entity,_target_points, action())
                _entity.energy -= action().cost
                actionDone.emit()
                finish()
                return
    return

func setState(state: State):
    _state = state
    return

func fillTargetHighlights():
    for point in _target_points:
        highlightMap.set_cell(0, point, 0, Highlights.RED, 0)
    return

func clearTargetHighlights():
    for point in _target_points:
        if _map_bfs.inRange(point, action().self_castable):
            highlightMap.set_cell(0, point, 0, Highlights.PURPLE, 0)
        else:
            highlightMap.set_cell(0, point, 0, Highlights.EMPTY, 0)
    _target_points = []
    return

func maxRange() -> int:
    return action().range

func shape() -> Array:
    return action().shape

func action() -> Action:
    if _action_type == ActionType.ATTACK:
        return _entity.attack
    if _action_type == ActionType.ACTION1:
        return _entity.action1
    if _action_type == ActionType.ACTION2:
        return _entity.action2
    return null

func finish():
    if _enabled:
        if _map_bfs != null:
            _map_bfs.resetHighlights(false, action().self_castable)
        _enabled = false
    return

func start(entity: Entity, action_type: int):
    _entity = entity
    _action_type = action_type
    _map_bfs = MapBFS.new()
    _map_bfs.init(_entity.location, maxRange(), tileMap, highlightMap, Highlights.PURPLE, _state, true, false)
    _map_bfs.resetHighlights(true, action().self_castable)
    _enabled = true
    return
