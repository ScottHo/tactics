class_name AiSpecialService extends Node2D

var _state: State
var _enabled: bool = false
var _entity: Entity
var _targets := []
var _counters := {}

@onready var tileMap: MainTileMap = $"../TileMap"
@onready var highlightMap: HighlightMap = $"../HighlightMap"

func setState(state: State):
    _state = state
    return

func mechanic_spread_targets():
    _targets = []
    var spread = [
        Vector2i(1,0), Vector2i(0,1), Vector2i(-1,0), Vector2i(0,-1),
        Vector2i(1,1), Vector2i(1,-1), Vector2i(-1,1), Vector2i(-1,-1)
        ]
    for ent in _state.all_allies_alive():
        _targets.append(ent.location)
        for vec in spread:
            _targets.append(ent.location + vec)
    for vec in _targets:
        highlightMap.highlightVec(vec, Highlights.RED)
    return

func mechanic_spread_effect():
    for vec in _targets:
        for ent in _state.all_allies_alive():
            if ent.location == vec:
                ent.loseHP(2)
    return

func mechanic_soak_targets():
    _targets = []
    var spread = [
        Vector2i(1,0), Vector2i(0,1), Vector2i(-1,0), Vector2i(0,-1),
        Vector2i(1,1), Vector2i(1,-1), Vector2i(-1,1), Vector2i(-1,-1)
        ]
    var target_ent = _state.all_allies_alive()[randi_range(0, len(_state.all_allies_alive())-1)]
    _targets.append(target_ent.location)
    highlightMap.highlightVec(target_ent.location, Highlights.RED)
    for vec in spread:
        _targets.append(vec + target_ent.location)
        highlightMap.highlightVec(target_ent.location + vec, Highlights.RED)
    return

func mechanic_soak_effect():
    var ents = []
    for vec in _targets:
        for ent in _state.all_allies_alive():
            if ent.location == vec:
                ents.append(ent)
    var damage = ceili(6.0/len(ents))
    for ent in ents:
        ent.loseHP(damage)
    return

func special_targets():
    if counter() % 2 == 0:
        mechanic_soak_targets()
    else:
        mechanic_spread_targets()
    return
    
func special_effect():
    if counter() % 2 == 0:
        mechanic_soak_effect()
    else:
        mechanic_spread_effect()
    return

func next_special_description():
    if (counter() + 1) % 2 == 0:
        return "Big Electric Blast:
Deals 6 damage spread over everyfriendly unit in a 3x3 area centered on a random friendly unit"
    else:
        return "Missles For Everyone:
Deals 2 damage to every friendly unit in a 3x3 area centered on every friendly unit"

func counter():
    return _counters.get(_entity.id, -1)

func next_special():
    _counters[_entity.id] = counter() + 1
    return
    
func finish():
    for vec in _targets:
        highlightMap.highlightVec(vec, Highlights.EMPTY)
    return
    
func start(entity: Entity):
    _entity = entity
    next_special()
    return
     
