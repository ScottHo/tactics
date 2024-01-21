class_name ActionCommon

static func do_action(state: State, _source: Entity, _targets: Array, action: Action):
    var targets = []
    for _ent in state.entities.allData():
        if _ent.location in _targets:
            targets.append(_ent)
    action.effect.call(_source, targets, action)
    if action.type == ActionType.ATTACK:
        var target: Entity = targets[0] # Assume only 1 tile for normal attacks
        if target.thorns_all:
            target.custom_text("Flying Thorns " + str(target.get_damage()) , Color.WHITE)
            for _ent in state.all_enemies_alive():
                target.damage_done += _source.damage_preview(target.get_damage())
                _ent.loseHP(target.get_damage())
        elif target.thorns:
            target.custom_text("Thorns " + str(target.get_damage()), Color.WHITE)
            target.damage_done += _source.damage_preview(target.get_damage())
            _source.loseHP(target.get_damage())
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
    else:
        callback.call()
    return

static func spawn_entity(location: Vector2i, e: Entity, parent: Node2D, tileMap: MainTileMap, state: State):
    var ent := e.clone()
    var sprite: EntitySprite  = load(ent.sprite_path).instantiate()
    parent.add_child(sprite)
    sprite.global_position = tileMap.pointToGlobal(location)
    ent.location = location
    if ent.is_ally:
        state.addAlly(ent)
        ent.set_energy(1)
        if ent.is_add:
            ent.interactable = InteractableFactory.add_drainer()
    else:
        state.addEnemy(ent)
    ent.sprite = sprite
    ent.update_sprite()
    return
