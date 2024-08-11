class_name MapBFS

var _bfs_points: Dictionary = {}
var _location: Vector2i
var _tile_map: TileMap
var _highlight_map: TileMap
var _range: int
var _range_color: Vector2i
var _mode: BFS_MODE
var _state: State


enum BFS_MODE { Attack, EnemyMove, AllyMove, Interact, Show}

func init(
        start_location: Vector2i,
        max_range: int,
        tileMap: TileMap,
        highlight_map: TileMap,
        range_color: Vector2i,
        state: State,
        mode: BFS_MODE):
    _location = start_location
    _range = max_range
    _tile_map = tileMap
    _highlight_map = highlight_map
    _range_color = range_color
    _state = state
    _mode = mode
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
            if not path_good(neighbor):
                continue
            if has_wall(current, neighbor):
                continue
            frontier.push_back(neighbor)
            _bfs_points[neighbor] = _bfs_points.get(current, []) + [neighbor]
    
    if _mode == BFS_MODE.AllyMove or _mode == BFS_MODE.EnemyMove:
        for key in _bfs_points.keys():
            if _check_on_entity(key) or _check_in_inter(key):
                _bfs_points.erase(key)
    return

func path_good(neighbor):
    var tile_data: TileData = _tile_map.get_cell_tile_data(0, neighbor)
    if tile_data == null:
        return false
    if not _mode == BFS_MODE.Attack:
        var tile_level: int = tile_data.get_custom_data("Level")
        if tile_level == -1:
            return false
        var ent: Entity = _state.entity_on_tile(neighbor)
        if ent != null:
            if ent.is_ally and _mode == BFS_MODE.EnemyMove:
                return false
            if not ent.is_ally and _mode == BFS_MODE.AllyMove:
                return false
    return true

func has_wall(tile1, tile2):
    var coords = [tile1, tile2]
    coords.sort()
    for wall in _state.walls:
        if wall.coords() == coords:
            return true
    return false

func _check_on_entity(vector):
    return _state.entity_on_tile(vector) != null

func _check_in_inter(vector):
     return _state.interactable_on_tile(vector) != null

func inRange(vector: Vector2i, can_target_self := false) -> bool:
    return _bfs_points.has(vector) and (vector != _location or can_target_self)
    
func in_melee_range(vector: Vector2i):
    var b = (_bfs_points.has(vector + Vector2i(1,0)) or \
            _bfs_points.has(vector + Vector2i(0,1)) or \
            _bfs_points.has(vector + Vector2i(-1,0)) or \
            _bfs_points.has(vector + Vector2i(0,-1)))
    b = b or (vector in  [_location + Vector2i(1,0),
                _location + Vector2i(0, 1),
                _location + Vector2i(-1,0),
                _location + Vector2i(0,-1)])
    return b

func closestInRange(vector) -> Vector2i:
    var minVec:= Vector2i(9999, 9999)
    var curMin:= 9999
    if vector == _location:
        return vector
    for vec in _bfs_points.keys():
        var newMin = abs(vector.x-vec.x) + abs(vector.y-vec.y)
        if newMin < curMin:
            curMin = newMin
            minVec = vec
    
    return minVec

func getPath(vector) -> Array:
    if vector == _location:
        return [] 
    return _bfs_points.get(vector, [])

func resetHighlights(calcRange: bool, highlight_self := false):
    if calcRange:
        calcRange_bfs()
    for i in range(MainTileMap.MIN_X, MainTileMap.MAX_X + 1):
        for j in range(MainTileMap.MIN_Y, MainTileMap.MAX_Y + 1):
            var curVec := Vector2i(i,j)
            if not highlight_self and curVec == _location:
                continue
            _highlight_map.highlightVec(curVec, Highlights.EMPTY)
            if calcRange and inRange(curVec, highlight_self):
                _highlight_map.highlightVec(curVec, _range_color)
    return
