class_name DeathService extends Node2D

var _state: State
var _enabled: bool = false
var _deaths_to_process: Array
var _graveyard: Array

func setState(state: State):
    _state = state
    return

func checkDeaths() -> bool:
    for _ent in _state.all_entities():
        var ent: Entity = _ent
        if ent.health > 0:
            continue
        if ent.id in _graveyard:
            continue
        _deaths_to_process.append(ent)
    return len(_deaths_to_process) > 0

func processDeaths():
    for _ent in _deaths_to_process:
        var ent : Entity = _ent
        ent.alive = false
        doDeathAnimation(ent)
        _graveyard.append(ent.id)
    _deaths_to_process = []
    return

func doDeathAnimation(entity: Entity):
    entity.sprite.setLabel("Dead")
    print(entity.display_name + " Died!")
    return
