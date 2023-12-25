class_name ActionFactory

static var shape_3x3 = [
        Vector2i(1,0), Vector2i(0,1), Vector2i(-1,0), Vector2i(0,-1),
        Vector2i(1,1), Vector2i(1,-1), Vector2i(-1,1), Vector2i(-1,-1)
        ]

static func add_base_attack(ent: Entity):
    var base_effect = func (user: Entity, targets: Array):
        user.gainThreat(1)
        for _ent in targets:
            _ent.loseHP(user.get_damage())
        return
    var d = "Deals base damage to any target. Gains 1 Threat."
    _add_test_action(ent, "Attack", d, 0, -1, false, 0, [], base_effect, true, ActionType.ATTACK)
    return

static func add_exert(ent: Entity, type: int):
    var effect = func (user: Entity, targets: Array):
        user.move_debuff_value = 3
        user.move_debuff_count = 1
        user.gainThreat(3)
        for _ent in targets:
            _ent.loseHP(user.get_damage() + 4)
        return
    var d = "Deals base damage + 4 to any target. Gains 3 Threat. Gains 3 movement penalty for 1 turn."
    _add_test_action(ent, "Exert", d, 0, -1, false, 2, [], effect, true, type)
    return

static func add_take_cover(ent: Entity, type: int):
    var effect = func (user: Entity, targets: Array):
        user.immune_count = 1
        return
    var d = "Target self to be completely immune for one damage instance until the next turn"
    _add_test_action(ent, "Take Cover", d, 0, 0, true, 2, [], effect, false, type)
    return

static func add_sticky_grenade(ent: Entity, type: int):
    var effect = func (user: Entity, targets: Array):
        user.gainThreat(1)
        for _ent in targets:
            _ent.loseHP(user.damage)
            _ent.move_debuff_value = 3
            _ent.move_debuff_count = 1
        return
    var d = "Throw a sticky bomb at target, dealing base damage. Inflicts 3 movement penalty to target for 1 turn"
    _add_test_action(ent, "Sticky Grenade", d, 2, -1, false, 2, [], effect, true, type)
    return
    
static func add_refuel(ent: Entity, type: int):
    var effect = func (user: Entity, targets: Array):
        user.moves_left = user.get_movement()
        return
    var d = "Target self to refill movement tiles"
    _add_test_action(ent, "Refuel", d, 0, 0, true, 2, [], effect, true, type)
    return

static func add_storm(ent: Entity, type: int):
    var effect = func (user: Entity, targets: Array):
        user.gainThreat(2)
        for _ent in targets:
            _ent.loseHP(user.get_damage() + 2)
        return
    var d = "Target a 3x3 area and deal base damage + 2. Gains 2 Threat."
    _add_test_action(ent, "Storm", d, -0, -1, true, 3, shape_3x3, effect, false, type)
    return

static func add_static_shield(ent: Entity, type: int):
    var effect = func (user: Entity, targets: Array):
        for _ent in targets:
            _ent.shield_value = 2
            _ent.shield_count = 1
        return
    var d = "Target a 3x3 area and add Shield 2 to all units for 1 damage instance."
    _add_test_action(ent, "Static Shield", d, 0, -1, true, 3, shape_3x3, effect, true, type)
    return

static func add_focused_repair(ent: Entity, type: int):
    var effect = func (user: Entity, targets: Array):
        for _ent in targets:
            _ent.gainHP(6)
        return
    var d = "Target a unit and gain 6 health."
    _add_test_action(ent, "Focused Repair", d, 0, -1, true, 2, [], effect, true, type)
    return

static func add_nano_field(ent: Entity, type: int):
    var effect = func (user: Entity, targets: Array):
        for _ent in targets:
            _ent.gainHP(3)
        return
    var d = "All units in a 3x3 area gain 3 health"
    _add_test_action(ent, "Nanofield", d, 0, -1, true, 2, shape_3x3, effect, true, type)
    return

static func add_weapons_upgade(ent: Entity, type: int):
    var effect = func (user: Entity, targets: Array):
        for _ent in targets:
            _ent.damage_modifier += 1
        return
    var d = "Target unit permanenlty gains 1 base damage."
    _add_test_action(ent, "Weapons Upgrade", d, 0, 1, false, 2, [], effect, true, type)
    return

static func add_engine_upgrade(ent: Entity, type: int):
    var effect = func (user: Entity, targets: Array):
        for _ent in targets:
            _ent.movement_modifier += 1
        return
    var d = "Target unit permanently gain 1 movement."
    _add_test_action(ent, "Engine Upgrade", d, 0, 1, false, 2, [], effect, true, type)
    return

static func add_snipe(ent: Entity, type: int):
    var effect = func (user: Entity, targets: Array):
        user.gainThreat(1)
        for _ent in targets:
            _ent.loseHP(user.get_damage())
        return
    var d = "Deals base damage to any target. Gains 1 Threat."
    _add_test_action(ent, "Snipe", d, 3, -1, false, 1, [], effect, true, type)
    return

static func add_titanium_bullet(ent: Entity, type: int):
    var effect = func (user: Entity, targets: Array):
        user.gainThreat(3)
        for _ent in targets:
            _ent.loseHP(user.get_damage() + 3)
        return
    var d = "Deals base damage + 6 to any target. Gains 3 Threat."
    _add_test_action(ent, "Titanium Bullet", d, 0, -1, false, 5, [], effect, true, type)
    return

static func _add_test_action(ent, display_name, description, range_modifier, strict_range, self_castable, cost, shape, effect, offensive, action_type):
    var action = Action.new()
    action.range_modifier = range_modifier
    action.strict_range = strict_range
    action.shape = shape
    action.effect = effect
    action.cost = cost
    action.self_castable = self_castable
    action.display_name = display_name
    action.description = description
    if offensive:
        action.target_color = Highlights.RED
    else:
        action.target_color = Highlights.BLUE
    if action_type == ActionType.ATTACK:
        ent.attack = action
    if action_type == ActionType.ACTION1:
        ent.action1 = action
    if action_type == ActionType.ACTION2:
        ent.action2 = action
    return
