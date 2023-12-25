class_name AiActionService extends Node2D

var _state: State
var _enabled: bool = false
var _entity: Entity
var _map_bfs: MapBFS

@onready var tileMap: MainTileMap = $"../TileMap"
@onready var highlightMap: HighlightMap = $"../HighlightMap"

func setState(state: State):
    _state = state
    return

func find_attack_location() -> Vector2i:
    var target_entity: Entity = null
    for _ent in _state.entities.allData():
        if not _map_bfs.inRange(_ent.location):
            continue    
        if target_entity == null:
            target_entity = _ent
            continue
        if target_entity.threat < _ent.threat:
            target_entity = _ent
            continue
    if target_entity == null:
        return Vector2i(999, 999)
    target_entity.threat -= 2
    highlightMap.set_cell(0, target_entity.location, 0, Highlights.RED, 0)
    return target_entity.location

func do_attack(target: Vector2i):
    var targets = VectorHelpers.get_target_coords(_entity.location, target, shape())
    ActionCommon.do_action(_state, _entity, targets, _entity.attack)
    return

func shape():
    return _entity.attack.shape

func finish():
    _map_bfs.resetHighlights(false)
    return
    
func start(entity: Entity):
    _entity = entity
    _map_bfs = MapBFS.new()
    var _range = _entity.get_range()
    _map_bfs.init(_entity.location, _range, tileMap, highlightMap, Highlights.PURPLE, _state, true, true, false)
    _map_bfs.resetHighlights(true)
    return
    
