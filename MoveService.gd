class_name MoveService extends Node2D

@onready var tileMap: MainTileMap = $"../TileMap"
@onready var highlightMap: HighlightMap = $"../HighlightMap"
var _enabled: = false
var finishInProcess: = false
var previous_coords: = Vector2i(-99,-99)
var _points = []
var _starting_point = Vector2i(0, 0)
var _state: State
var maxMoves: int = -1
var _map_bfs: MapBFS
var _entity: Entity

signal movesFound

func _ready():
    return

func _input(event):
    if not _enabled:
        return
    if event is InputEventMouseMotion:
        var coords: Vector2i = tileMap.globalToPoint(get_global_mouse_position())
        if previous_coords != coords:
            highlightPath(true)
            previous_coords = coords
            _points = []
            if not _map_bfs.inRange(coords):
                return
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
                var poses = tileMap.arrayToGlobal(_points)
                _entity.moves_left -= len(_points)
                _entity.location = _points[-1]
                movesFound.emit(poses)
                return

func highlightPath(clear: bool):
    var color = Highlights.YELLOW
    if clear:
        color = Highlights.PURPLE
    for point in _points:
        highlightMap.highlightVec(point, color)
    return

func finish():
    if _enabled:
        if _map_bfs != null:
            _map_bfs.resetHighlights(false)
        _enabled = false
    return

func start(entity: Entity):
    _entity = entity
    _starting_point = entity.location
    maxMoves = entity.moves_left
    _points = []
    previous_coords = Vector2i(-99,-99)
    _map_bfs = MapBFS.new()
    _map_bfs.init(_starting_point, maxMoves, tileMap, highlightMap, Highlights.PURPLE, _state, false, false, false)
    _map_bfs.resetHighlights(true)
    _enabled = true    
    return

func setState(state: State):
    _state = state
    return

