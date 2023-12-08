class_name ActionCommon

static func do_action(state: State, _source: Entity, _targets: Array, action: Action):
    var targets = []
    for _ent in state.entities.allData():
        if _ent.location in _targets:
            targets.append(_ent)
    action.effect.call(_source, targets)
    return
