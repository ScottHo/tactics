class_name ActionService extends Node2D

var _state: State
var _enabled: bool = false
var _entity: Entity
var _action_idx: int = -1
var _actions: Array[Action] = [null, null, null , null]
var _previous_coords: Vector2i
var _target_points: Array[Vector2i] = []
var _bfs_points: Dictionary = {}
 
@onready var tileMap: MainTileMap = $"../TileMap"
@onready var highlightMap: HighlightMap = $"../HighlightMap"

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
            if not inRange(coords):
                return
            _target_points.append(coords)
            var direction := findDirection(coords)
            for vec in shape():
                var v = computeRotatedVectors(vec, direction)
                _target_points.append(coords+v)
            fillTargetHighlights()
    if event is InputEventMouseButton and event.is_pressed():
        match event.button_index:
            MOUSE_BUTTON_LEFT:
                if len(_target_points) <= 0:
                    return
                for _ent in _state.entities.allData():
                    if _ent.location in _target_points:
                        _ent.loseHP(damage())
                finish()
                return
    return

func setState(state: State):
    _state = state
    return

func calcRange_bfs():
    _bfs_points = {}
    var frontier: Array[Vector2i] = [_entity.location]
    while len(frontier) > 0:
        var current = frontier.pop_front()
        if _bfs_points.get(current, 0) >= maxRange():
            continue
        
        var neighbors = [
            current + Vector2i(0, 1),
            current + Vector2i(1, 0),
            current + Vector2i(0, -1),
            current + Vector2i(-1, 0)
            ]
        
        for neighbor in neighbors:
            if _bfs_points.has(neighbor):
                continue
            var tileData: TileData = tileMap.get_cell_tile_data(0, neighbor)
            var tileLevel: int = tileData.get_custom_data("Level")
            if tileLevel == -1:
                continue
            frontier.push_back(neighbor)
            _bfs_points[neighbor] = _bfs_points.get(current, 0) + 1
    return
    
func inRange(vector) -> bool:
    return _bfs_points.has(vector) and vector != _entity.location
        
func computeRotatedVectors(target: Vector2i, direction: Vector2i) -> Vector2i:
    if direction == Vector2i(0,-1):
        var rotVec = Vector2i(0,0)
        rotVec.x = target.y
        rotVec.y = -target.x
        return rotVec
    if direction == Vector2i(-1,0):
        var rotVec = Vector2i(0,0)
        rotVec.x = -target.x
        rotVec.y = -target.y
        return rotVec
    if direction == Vector2i(0,1):
        var rotVec = Vector2i(0,0)
        rotVec.x = -target.y
        rotVec.y = target.x
        return rotVec
    return target
    

func findDirection(target: Vector2i) -> Vector2i:
    var x_diff = _entity.location.x - target.x
    var y_diff = _entity.location.y - target.y
    
    if abs(x_diff) >= abs(y_diff):
        if x_diff < 0:
            return Vector2i(1,0)
        return Vector2i(-1,0)
        
    if y_diff < 0:
        return Vector2i(0,1)
    return Vector2i(0,-1)

func fillTargetHighlights():
    for point in _target_points:
        highlightMap.set_cell(0, point, 0, Highlights.RED, 0)
    return

func clearTargetHighlights():
    for point in _target_points:
        if inRange(point):
            highlightMap.set_cell(0, point, 0, Highlights.PURPLE, 0)
        else:
            highlightMap.set_cell(0, point, 0, Highlights.EMPTY, 0)
    _target_points = []
    return

func resetHighlights(calcRange: bool):
    if calcRange:
        calcRange_bfs()
    for i in range(9):
        for j in range(-6,5):
            var curVec := Vector2i(i,j)
            highlightMap.set_cell(0, curVec , 0, Highlights.EMPTY, 0)
            if calcRange and inRange(curVec):
                highlightMap.set_cell(0, curVec , 0, Highlights.PURPLE, 0)
    return

func setAction(idx: int, action: Action):
    _actions[idx] = action
    return

func maxRange() -> int:
    return _actions[_action_idx].range

func shape() -> Array[Vector2i]:
    return _actions[_action_idx].shape

func damage() -> int:
    return _actions[_action_idx].damage

func finish():
    resetHighlights(false)
    _enabled = false
    return

func start(entity: Entity, action_idx: int):
    _entity = entity
    _action_idx = action_idx
    resetHighlights(true)
    _enabled = true
    return
