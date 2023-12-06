class_name MapBFS

var _bfs_points: Dictionary = {}
var _location: Vector2i
var _tile_map: TileMap
var _highlight_map: HighlightMap
var _range: int
var _range_color: Vector2i
var _ignore_entities: bool
var _ignore_walls: bool
var _state: State

func init(
        start_location: Vector2i,
        max_range: int,
        tileMap: TileMap,
        highlight_map: HighlightMap,
        range_color: Vector2i,
        state: State,
        ignore_entities: bool,
        ignore_walls: bool):
    _location = start_location
    _range = max_range
    _tile_map = tileMap
    _highlight_map = highlight_map
    _range_color = range_color
    _state = state
    _ignore_entities = ignore_entities
    _ignore_walls = ignore_walls
    return

func calcRange_bfs():
    _bfs_points = {_location: [] }
    var frontier: Array[Vector2i] = [_location]
    while len(frontier) > 0:
        var current = frontier.pop_front()
        if len(_bfs_points.get(current, [])) >= _range:
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
            var tile_data: TileData = _tile_map.get_cell_tile_data(0, neighbor)
            if tile_data == null:
                continue
            if not _ignore_walls:
                var tile_level: int = tile_data.get_custom_data("Level")
                if tile_level == -1:
                    continue
            if not _ignore_entities:
                if _check_on_entity(neighbor):
                    continue
            frontier.push_back(neighbor)
            _bfs_points[neighbor] = _bfs_points.get(current, []) + [neighbor]
    return

func _check_on_entity(vector):
    for _entity in _state.entities.allData():
        if _entity.location == vector:
            return true
    return false

func inRange(vector: Vector2i, can_target_self := false) -> bool:
    return _bfs_points.has(vector) and (vector != _location or can_target_self)
    
func closestInRange(vector) -> Vector2i:
    var minVec:= Vector2i(9999, 9999)
    var curMin:= 9999
    for vec in _bfs_points.keys():
        var newMin = abs(vector.x-vec.x) + abs(vector.y-vec.y)
        if newMin < curMin:
            curMin = newMin
            minVec = vec
    return minVec

func getPath(vector) -> Array:
    return _bfs_points.get(vector, [])

func resetHighlights(calcRange: bool, highlight_self := false):
    if calcRange:
        calcRange_bfs()
    for i in range(0, 15):
        for j in range(-6, 9):
            var curVec := Vector2i(i,j)
            if not highlight_self and curVec == _location:
                continue
            _highlight_map.set_cell(0, curVec, 0, Highlights.EMPTY, 0)
            if calcRange and inRange(curVec, highlight_self):
                _highlight_map.set_cell(0, curVec, 0, _range_color, 0)
    return
