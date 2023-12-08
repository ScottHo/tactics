class_name AiMoveService extends Node2D

var _state: State
var _enabled: bool = false
var _entity: Entity
var _map_bfs: MapBFS

@onready var tileMap: MainTileMap = $"../TileMap"
@onready var highlightMap: HighlightMap = $"../HighlightMap"

func setState(state: State):
    _state = state
    return

func find_move() -> Array:
    var path = _find_move()
    _entity.location = path[-1]
    return path

func _find_move() -> Array:
    var target := _find_target()
    if target ==  null:
        return _map_bfs.getPath(_find_closest())
    var path := _map_bfs.getPath(target.location)
    if len(path) <= 1:
        return [_entity.location]
    path.pop_back()
    _entity.location = path[-1]
    return path

func _find_target() -> Entity:
    var target: Entity
    for ent_id in _state.threatOrder():
        if _map_bfs.inRange(_state.get_entity(ent_id).location):
            target = _state.get_entity(ent_id)
            return target
    return null

func _find_closest() -> Vector2i:
    var highest_threat_id = _state.threatOrder()[0]
    var loc = _state.get_entity(highest_threat_id).location
    return _map_bfs.closestInRange(loc)

func showPath(path):
    var color = Highlights.YELLOW
    for point in path:
        highlightMap.set_cell(0, point , 0, color, 0)
    return
    
func finish():
    _map_bfs.resetHighlights(false)
    return
    
func start(entity: Entity):
    _entity = entity
    _map_bfs = MapBFS.new()
    _map_bfs.init(_entity.location, _entity.movement, tileMap, highlightMap, Highlights.PURPLE, _state, false, false)
    _map_bfs.resetHighlights(true)
    return
    
