class_name AiSpecialService extends Node2D

var _state: State
var _enabled: bool = false
var _entity: Entity
var _specials: Array
var _targets := []
var _counters := {}

@onready var tileMap: MainTileMap = $"../TileMap"
@onready var highlightMap: HighlightMap = $"../HighlightMap"

func setState(state: State):
    _state = state
    return

func targets_per_entity(target_entity: Entity) -> Array:
    var vecs = [] 
    if special().shape == Special.Shape.SQUARE_3x3:
        vecs = [Vector2i(0,0),
        Vector2i(1,0), Vector2i(0,1), Vector2i(-1,0), Vector2i(0,-1),
        Vector2i(1,1), Vector2i(1,-1), Vector2i(-1,1), Vector2i(-1,-1)
        ]
        for i in len(vecs):
            vecs[i] += target_entity.location
    return vecs

func mechanic_spread_effect():
    for vec in _targets:
        for ent in _state.all_allies_alive():
            if ent.location == vec:
                ent.loseHP(special().damage)
    return

func mechanic_soak_effect():
    var ents = []
    for vec in _targets:
        for ent in _state.all_allies_alive():
            if ent.location == vec:
                ents.append(ent)
    var damage = float(special().damage)
    damage = ceili(damage/len(ents))
    for ent in ents:
        ent.loseHP(damage)
    return

func find_special_targets():
    _targets = []
    if special().target == Special.Target.ALL:
        for ent in _state.all_allies_alive():
            _targets.append_array(targets_per_entity(ent))

    if special().target == Special.Target.RANDOM:
        var ent = _state.all_allies_alive()[randi_range(0, len(_state.all_allies_alive())-1)]
        _targets = targets_per_entity(ent)

    if special().target == Special.Target.THREAT:
        var ent = _state.threatOrder()[0]
        _targets = targets_per_entity(ent)

    for v in _targets:
        highlightMap.highlightVec(v, Highlights.RED)
    return
    
func do_special_effect():
    if special().mechanic == Special.Mechanic.SOAK:
        mechanic_soak_effect()
    if special().mechanic == Special.Mechanic.SPREAD:
        mechanic_spread_effect()
    return

func next_special_description():
    var s: Special = next_special()
    return s.display_name + "\n" + s.description

func special() -> Special:
    return _specials[counter() % len(_specials)]

func counter():
    # Default at -2, as first turn it will go to -1 and we want to skip first
    return _counters.get(_entity.id, -2)

func cycle_special():
    _counters[_entity.id] = counter() + 1
    return

func next_special():
    return _specials[(counter() + 1) % len(_specials)]
    
func finish():
    for vec in _targets:
        highlightMap.highlightVec(vec, Highlights.EMPTY)
    return
    
func start(entity: Entity, mission: Mission):
    _entity = entity
    _specials = mission.specials
    cycle_special()
    return
     
