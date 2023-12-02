class_name MoveService extends Node2D

@onready var tileMap: MainTileMap = $"../TileMap"
@onready var highlightMap: HighlightMap = $"../HighlightMap"
var enabled: = false
var finishInProcess: = false
var previous_coords: = Vector2i(-99,-99)
var _points = []
var _starting_point = Vector2i(0, 0)
var _state: State
var maxMoves: int = -1
var _map_bfs: MapBFS

signal movesFound

func _ready():
    return

func _input(event):
    if not enabled:
        return
    if event is InputEventMouseMotion:
        var coords: Vector2i = tileMap.globalToPoint(get_global_mouse_position())
        if previous_coords != coords:
            highlightPath(true)
            if not _map_bfs.inRange(coords):
                return
            previous_coords = coords
            var points = _map_bfs.getPath(coords)
            if len(points) == 0:
                return
            _points = points
            highlightPath(false)
            return
    
    if event is InputEventMouseButton and event.is_pressed():
        match event.button_index:
            MOUSE_BUTTON_LEFT:
                if len(_points) <= 0:
                    return
                var poses = []
                for point in _points:
                    poses.append(tileMap.pointToGlobal(point))
                movesFound.emit(poses, _points[-1])
                enabled = false
                return

func highlightPath(clear: bool):
    var color = Highlights.YELLOW
    if clear:
        color = Highlights.PURPLE
    for point in _points:
        highlightMap.set_cell(0, point , 0, color, 0)
    return

func finish():
    _map_bfs.resetHighlights(false)
    return

func start(entity: Entity):
    _starting_point = entity.location
    maxMoves = entity.moves_left
    _points = []
    previous_coords = Vector2i(-99,-99)
    _map_bfs = MapBFS.new()
    _map_bfs.init(_starting_point, maxMoves, tileMap, highlightMap, Highlights.PURPLE, _state, false, false)
    _map_bfs.resetHighlights(true)
    enabled = true    
    return

func setState(state: State):
    _state = state
    return

