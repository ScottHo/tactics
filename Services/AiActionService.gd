class_name AiActionService extends Node2D

var _state: State
var _entity: Entity
var _map_bfs: MapBFS
var _targets: Array

@onready var tileMap: MainTileMap = $"../TileMap"
@onready var highlightMap: HighlightMap = $"../HighlightMap"
@onready var highlightMap2: TileMap = $"../HighlightMap2"
@onready var effects : Node2D = $Effects

signal done

func setState(state: State):
    _state = state
    return

func find_attack_location() -> Vector2i:
    var target_entity: Entity = null
    for _ent in _state.all_allies_alive():
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
    target_entity.loseThreat(1)
    highlightMap2.highlightVec(target_entity.location, Highlights.ATTACK)
    return target_entity.location

func do_attack(target: Vector2i):
    ActionCommon.face_direction(_entity, target)
    _targets = Utils.get_target_coords(_entity.location, target, shape())
    _entity.action_animation(func():
        ActionCommon.do_action_animation(effects, _entity.attack, _targets, tileMap, _state, action_animation_done)
        , ActionType.ATTACK)
    return

func action_animation_done():
    ActionCommon.do_action(_state, _entity, _targets, _entity.attack)
    done.emit()
    return

func shape():
    return _entity.attack.shape

func finish():
    for t in _targets:
        highlightMap2.highlightVec(t, Highlights.EMPTY)
    _map_bfs.resetHighlights(false)
    return
    
func start(entity: Entity):
    _entity = entity
    _map_bfs = MapBFS.new()
    var _range = _entity.get_range()
    _map_bfs.init(_entity.location, _range, tileMap, highlightMap, Highlights.ORANGE, _state, MapBFS.BFS_MODE.Attack)
    _map_bfs.resetHighlights(true)
    return
    
