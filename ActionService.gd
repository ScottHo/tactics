class_name ActionService extends Node2D

var _state: State
var _enabled: bool = false
var _entity: Entity
var _action_type: int = -1
var _previous_coords: Vector2i
var _target_points: Array = []
var _map_bfs: MapBFS
var _targets_all: Array = []
@onready var tileMap: MainTileMap = $"../TileMap"
@onready var highlightMap: HighlightMap = $"../HighlightMap"
@onready var effects : Node2D = $Effects

signal actionDone

func _ready():
    return

func _input(event):
    if not _enabled:
        return
    if event is InputEventMouseMotion:
        var coords: Vector2i = tileMap.globalToPoint(get_global_mouse_position())
        if _previous_coords != coords:
            _previous_coords = coords            
            if TargetTypes.NO_BFS:
                highlight_for_no_bfs()
            else:
                highlight_for_bfs()
            
    if event is InputEventMouseButton and event.is_pressed():
        match event.button_index:
            MOUSE_BUTTON_LEFT:
                if len(_target_points) <= 0:
                    return
                if len(_target_points) == 1:
                    if not validate_single_target():
                        return
                if action().cost() != 0:
                    _entity.update_energy(-action().cost())
                _entity.action_animation(action_animation_effects)
                if action().type == ActionType.ACTION2:
                    _entity.ultimate_used = true
                _enabled = false
                return
    return

func highlight_for_bfs():
    clearTargetHighlights()
    if not _map_bfs.inRange(_previous_coords, action().self_castable()):
        return
    _target_points = Utils.get_target_coords(_entity.location, _previous_coords, shape())
    if action().type == ActionType.ATTACK and _entity.chain_attack:
        var point = add_chain_target(_target_points[0])
        if point != Vector2i(999,999):
            _target_points.append(point)
    fillTargetHighlights()
    return

func add_chain_target(start_vec):
    var potential_targets = {1:[], 2:[], 3:[]}
    for enemy in _state.all_enemies_alive():
        var total = enemy.location - start_vec
        var diff = abs(total.x) + abs(total.y)
        if diff > 0 and diff <= 3:
            potential_targets[diff].append(enemy)
    if len(potential_targets[1]) > 0:
        return potential_targets[1][0].location
    if len(potential_targets[2]) > 0:
        return potential_targets[2][0].location
    if len(potential_targets[3]) > 0:
        return potential_targets[3][0].location
    return Vector2i(999,999)

func highlight_for_no_bfs():
    if _targets_all.has(_previous_coords):
        for t in _targets_all:
            highlightMap.highlightVec(t, Highlights.PURPLE)
        _target_points = []
    else:
        for t in _targets_all:
            highlightMap.highlightVec(t, Highlights.RED)
        _target_points = _targets_all.duplicate(true)
    return

func validate_single_target():
    var ent = _state.entity_on_tile(_target_points[0])
    var inter = _state.interactable_on_tile(_target_points[0])
    if action().affects() != TargetTypes.EMPTY:
        if ent == null:
            return false
        if TargetTypes.ALLIES_LIST.has(action().affects()):
            if not ent.is_ally:
                return false
        if TargetTypes.ENEMIES_LIST.has(action().affects()):
            if ent.is_ally:
                return false
    else:
        if ent != null or inter != null:
            return false
    return true

func action_animation_effects():
    ActionCommon.do_action_animation(effects, action(), _target_points, tileMap, action_animation_done)
    return

func action_animation_done():
    ActionCommon.do_action(_state, _entity, _target_points, action())
    if action().spawn != null:
        print("SPAWN")
        for target in _target_points:
            ActionCommon.spawn_entity(target, action().spawn.clone(), $"../", tileMap, _state)
        action().spawn = null
    _entity.gainThreat(action().threat())
    effects.get_child(0).queue_free()
    actionDone.emit()
    finish()
    return

func setState(state: State):
    _state = state
    return

func fillTargetHighlights():
    for point in _target_points:
        highlightMap.highlightVec(point, Highlights.RED)
    return

func clearTargetHighlights():
    for point in _target_points:
        if _map_bfs.inRange(point, action().self_castable()):
            highlightMap.highlightVec(point, Highlights.PURPLE)
        else:
            highlightMap.highlightVec(point, Highlights.EMPTY)
    _target_points = []
    return

func maxRange() -> int:
    if action().self_cast_only():
        return 0
    return _entity.get_range() + action().range_modifier()

func shape() -> Array:
    return action().shape

func action() -> Action:
    if _action_type == ActionType.ATTACK:
        return _entity.attack
    if _action_type == ActionType.ACTION1:
        return _entity.action1
    if _action_type == ActionType.ACTION2:
        return _entity.action2
    return null

func finish():
    if _map_bfs != null:
        _map_bfs.resetHighlights(false, action().self_castable())
    _enabled = false
    return

func show_targets_all():
    _targets_all = []
    if action().affects() == TargetTypes.ALL or action().affects() == TargetTypes.ALL_ALLIES:
        for e in _state.all_allies_alive(false):
            _targets_all.append(e.location)
            highlightMap.highlightVec(e.location, Highlights.PURPLE)
    if action().affects() == TargetTypes.ALL or action().affects() == TargetTypes.ALL_ENEMIES:
        for e in _state.all_enemies_alive():
            _targets_all.append(e.location)
            highlightMap.highlightVec(e.location, Highlights.PURPLE)
    return
        
func start(entity: Entity, action_type: int):
    _entity = entity
    _action_type = action_type
    if TargetTypes.NO_BFS.has(action().affects()):
        show_targets_all()
    else:
        _map_bfs = MapBFS.new()
        _map_bfs.init(_entity.location, maxRange(), tileMap, highlightMap, Highlights.PURPLE, _state, MapBFS.BFS_MODE.Attack)
        _map_bfs.resetHighlights(true, action().self_castable())
    _enabled = true
    return
