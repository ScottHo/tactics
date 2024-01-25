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

static func do_action_animation(parent: Node2D, action, _targets: Array, tileMap: TileMap, state: State, callback: Callable):
    var node = Node2D.new()
    parent.add_child(node)
    if action.target_animation != "":
        for point in _targets:
            var _ent = state.entity_on_tile(point)
            if _ent != null:
                if action.target_animation == TargetAnimations.BUFF:
                    _ent.buff_animation()
                if action.target_animation == TargetAnimations.HIT:
                    _ent.hit_animation()
    if action.animation_path != "":
        for point in _targets:
            var s: EffectsAnimation = load(action.animation_path).instantiate()
            node.add_child(s)
            s.global_position = tileMap.pointToGlobal(point)
            s.position.y -= 40
            s.done.connect(callback)
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

static func spawn_inter(location: Vector2i, inter: Interactable, parent: Node2D, tileMap: MainTileMap, state: State):
    print_debug("Spawning Interactable at " + str(location))    
    inter.location = location
    var sprite: InteractableSprite  = load(inter.sprite_path).instantiate()
    sprite.load_texture(inter.icon_path, inter.color)
    inter.set_sprite(sprite)
    parent.add_child(sprite)
    sprite.global_position = tileMap.pointToGlobal(inter.location)
    state.add_interactable(inter)
    return

static func face_direction(entity: Entity, target: Vector2i):
    var direction := target - entity.location
    if direction.x >= direction.y:
        if direction.x + direction.y >= 0:
            entity.face_direction(Vector2i(1,0))
        else:
            entity.face_direction(Vector2i(0,-1))
    else:
        if direction.x + direction.y >= 0:
            entity.face_direction(Vector2i(0,1))
        else:
            entity.face_direction(Vector2i(-1,0))
    return
