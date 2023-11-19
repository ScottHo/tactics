class_name MoveService extends Node2D

@onready var tileMap = $"../TileMap"
@onready var highlightMap = $"../HighlightService"
var astar = AStarGrid2D.new()
var enabled: = false
var finishInProcess: = false
var previous_vector: = Vector2i(-99,-99)
var _points = []
var _starting_point = Vector2i(0, 0)
var _state: State
var maxMoves: int = -1

signal movesFound
signal numMovesUpdated

func _ready():
    astar.diagonal_mode = AStarGrid2D.DIAGONAL_MODE_NEVER
    astar.region = Rect2i(0, -6, 9, 11)
    astar.update()
    
    for i in range(9):
        for j in range(-6,5):
            var tileData: TileData = tileMap.get_cell_tile_data(0, Vector2i(i,j))
            var tileLevel: int = tileData.get_custom_data("Level")
            astar.set_point_solid(Vector2i(i, j), tileLevel == -1)
            highlightMap.set_cell(0, Vector2i(i,j), 0, Vector2i(1,0), 0)
    return

func _input(event):
    if not enabled:
        return
    if event is InputEventMouseMotion:
        var coords: Vector2i = globalToPoint(get_global_mouse_position())
        if previous_vector != coords:
            for point in _points:
                highlightMap.set_cell(0, point, 0, Vector2i(1,0), 0)
            _points = []
            if not astar.is_in_bounds(coords.x, coords.y):
                return            
            previous_vector = coords
            
            var startPoint = _starting_point
            var points: Array[Vector2i] = astar.get_id_path(startPoint, coords)
            if len(points) == 0:
                return
            if len(points) > maxMoves:
                return          
            _points = []
            for point in points:
                _points.append(point)
                highlightMap.set_cell(0, point, 0, Vector2i(0,0), 0)
            numMovesUpdated.emit(len(_points) - 1)
                
    if event is InputEventMouseButton and event.is_pressed():
        match event.button_index:
            MOUSE_BUTTON_LEFT:
                if len(_points) <= 0:
                    return
                var poses = []
                for point in _points:
                    poses.append(pointToGlobal(point))
                movesFound.emit(poses, _points[-1])
                enabled = false
                return

func globalToPoint(pos):
    return tileMap.local_to_map(tileMap.to_local(pos))

func pointToGlobal(point):
    return tileMap.to_global(tileMap.map_to_local(point))

func updateEntityLocations():
    for i in range(1,8):
        for j in range(-5,4):
            astar.set_point_solid(Vector2i(i, j), false)
    for id in _state.entities.allKeys():
        astar.set_point_solid(_state.entities.get_data(id).location, true)
    return

func finish():
    for point in _points:
        highlightMap.set_cell(0, point, -1, Vector2i(1,0), 0)
    return

func start(entity: Entity):
    _starting_point = entity.location
    maxMoves = entity.movement
    _points = []
    previous_vector = Vector2i(-99,-99)
    enabled = true
    return

func setState(state: State):
    _state = state
    return

