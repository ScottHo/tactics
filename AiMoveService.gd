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
    if len(path) != 0:
        _entity.location = path[-1]
    return path

func _find_move() -> Array:
    var target := _find_target()
    if target == null:
        print_debug("Could not find a target in range")
        return _map_bfs.getPath(_find_closest())
    var path := _map_bfs.getPath(_map_bfs.closestInRange(target.location))
    if len(path) < 1:
        return [_entity.location]
    _entity.location = path[-1]
    return path

func _find_target() -> Entity:
    for ent in _state.threatOrder():
        if _map_bfs.in_melee_range(ent.location):
            print_debug("Found enemy " + ent.display_name + " with threat " + str(ent.threat))
            return ent
    return null

func _find_closest() -> Vector2i:
    var highest_threat = _state.threatOrder()[0]
    var loc = highest_threat.location
    return _map_bfs.closestInRange(loc)

func showPath(path):
    var color = Highlights.YELLOW
    for point in path:
        highlightMap.highlightVec(point, color)
    return
    
func finish():
    _map_bfs.resetHighlights(false)
    return
    
func start(entity: Entity):
    _entity = entity
    _map_bfs = MapBFS.new()
    _map_bfs.init(_entity.location, _entity.get_movement(), tileMap, highlightMap, Highlights.PURPLE, _state, false, false, false)
    _map_bfs.resetHighlights(true)
    return
    
