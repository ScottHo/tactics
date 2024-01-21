class_name AuraService extends Node2D

var _state: State

func set_state(state: State):
    _state = state
    return

func update():
    var all_allies = _state.all_allies_alive()
    for ent in all_allies:
        ent.reset_auras()
    for ent in all_allies:
        if ent.passive == null:
            continue
        if not ent.passive.is_aura:
            continue
        for other_ent in all_allies:
            check_and_do_effect(ent, other_ent)
    return

func check_and_do_effect(ent: Entity, other_ent: Entity):
    var vecs = [Vector2i(0,0),
                Vector2i(1,0), Vector2i(0,1), Vector2i(0,-1), Vector2i(-1,0),
                Vector2i(1,1), Vector2i(1,-1), Vector2i(-1,-1), Vector2i(-1,1)]
    for vec in vecs:
        if ent.location + vec == other_ent.location:
            ent.passive.aura_effect.call(other_ent)
            return
    return
