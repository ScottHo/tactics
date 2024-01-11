class_name ActionCommon

static func do_action(state: State, _source: Entity, _targets: Array, action: Action):
    var targets = []
    for _ent in state.entities.allData():
        if _ent.location in _targets:
            targets.append(_ent)
    action.effect.call(_source, targets, action)
    return

static func do_action_animation(parent: Node2D, action, _targets: Array, tileMap: TileMap, callback: Callable):
    var animation_signal_connected = false
    var node = Node2D.new()
    parent.add_child(node)
    if action.animation_path != "":
        for point in _targets:
            var s: EffectsAnimation = load(action.animation_path).instantiate()
            node.add_child(s)
            s.global_position = tileMap.pointToGlobal(point)
            s.position.y -= 40
            if not animation_signal_connected:
                s.done.connect(callback)
                animation_signal_connected = true
    return
