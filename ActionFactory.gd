class_name ActionFactory

static var shape_3x3 = [
        Vector2i(1,0), Vector2i(0,1), Vector2i(-1,0), Vector2i(0,-1),
        Vector2i(1,1), Vector2i(1,-1), Vector2i(-1,1), Vector2i(-1,-1)
        ]

static func add_base_attack(ent: Entity):
    var stats = {
        "Affects": "Enemy Units",
        "Cost": 0,
        "Threat Gain": 1,
    }
    var base_effect = func (user: Entity, targets: Array, action: Action):
        user.gainThreat(1)
        for _ent in targets:
            _ent.loseHP(user.get_damage())
        return
    var d = "Deals damage to any target"
    _add_action(ent, "Normal Attack", d, [], base_effect, ActionType.ATTACK, stats)
    return

static func add_exert(ent: Entity, type: int):
    var stats = {
        "Affects": "Enemy Units",
        "Cost": 3,
        "Damage Amp": [2, 2, 3, 3],
        "Movement Penalty": [3, 2, 2, 1],
        "Movement Penalty Duration": 1,
        "Threat Gain": 3,
    }
    var effect = func (user: Entity, targets: Array, action: Action):
        user.move_debuff_value =  action.get_from_stats("Movement Penalty")
        user.move_debuff_count = action.get_from_stats("Movement Penalty Duration")
        user.gainThreat(action.get_from_stats("Threat Gain"))
        for _ent in targets:
            _ent.loseHP(user.get_damage() + user.get_damage())
        return
    var d = "Brutus Exterts Itself And hits so hard its wheels break down for a turn."
    
    _add_action(ent, "Exert", d, [], effect, type, stats)
    return

static func add_take_cover(ent: Entity, type: int):
    var stats = {
        "Affects": "Self",
        "Cost": 1,
        "Shield Amount": [2, 4, 6, 8],
    }
    var effect = func (user: Entity, targets: Array, action: Action):
        user.shield_count = action.get_from_stats("Shield Amount")
        return
    var d = "Manuever itself and shows its hard exterior, shielding itself for a turn"
    _add_action(ent, "Take Cover", d, [], effect, type, stats)
    return

static func add_oil_bomb(ent: Entity, type: int):
    var stats = {
        "Affects": "Enemy Units",
        "Cost": 2,
        "Additional Range": 2,
        "Additional Damage": [0, 1, 2, 3],
        "Movement Debuff": [2, 2, 3, 3],
        "Movement Debuff Duration": 1,
        "Threat Gain": 1,
    }
    var effect = func (user: Entity, targets: Array, action: Action):
        user.gainThreat(1)
        for _ent in targets:
            _ent.loseHP(user.damage + action.get_from_stats("Additional Damage"))
            _ent.move_debuff_value = action.get_from_stats("Movement Debuff")
            _ent.move_debuff_count = action.get_from_stats("Movement Debuff Duration")
        return
    var d = "Cover a target with its old oil, slowing it's movement"
    _add_action(ent, "Oil Bomb", d, [], effect, type, stats)
    return
    
static func add_lubricate(ent: Entity, type: int):
    var stats = {
        "Affects": "Self",
        "Cost": 1,
        "Extra Moves": [2,3,4,5] 
    }
    var effect = func (user: Entity, targets: Array, action: Action):
        user.moves_left += action.get_from_stats("Extra Moves")
        return
    var d = "Lubricate your axles to gain extra movement for the turn"
    _add_action(ent, "Lubricate", d, [], effect, type, stats)
    return

static func add_storm(ent: Entity, type: int):
    var stats = {
        "Affects": "All Units",
        "Cost": 2,
        "Additional Damage": [2, 3, 4, 5],
        "Threat Gain": 2,
    }
    var effect = func (user: Entity, targets: Array, action: Action):
        user.gainThreat(2)
        for _ent in targets:
            _ent.loseHP(user.get_damage() + action.get_from_stats("Additional Damage"))
        return
    var d = "Create an unstable electro magnetic field and make everything not work"
    _add_action(ent, "Storm", d, shape_3x3, effect, type, stats)
    return

static func add_static_shield(ent: Entity, type: int):
    var stats = {
        "Affects": "All Units",
        "Cost": 2,
        "Shield Amount": [2, 3, 4, 5],
        "Shield Duration": 2
    }
    var effect = func (user: Entity, targets: Array, action: Action):
        for _ent in targets:
            _ent.shield_value = action.get_from_stats("Shield Amount")
            _ent.shield_count = 2
        return
    var d = "Create a stable electro magnetic field and shield everything"
    _add_action(ent, "Static Shield", d, shape_3x3, effect, type, stats)
    return

static func add_focused_repair(ent: Entity, type: int):
    var stats = {
        "Affects": "All Friendly Units",
        "Cost": 2,
        "Heal Amount": [5, 7, 9, 11],
    }
    var effect = func (user: Entity, targets: Array, action: Action):
        for _ent in targets:
            _ent.gainHP(action.get_from_stats("Heal Amount"))
        return
    var d = "Summon all the nanobots to heal one friend"
    _add_action(ent, "Focused Repair", d, [], effect, type, stats)
    return

static func add_nano_field(ent: Entity, type: int):
    var stats = {
        "Affects": "All Friendly Units",
        "Cost": 2,
        "Heal Amount": [3, 4, 5, 6],
    }
    var effect = func (user: Entity, targets: Array, action: Action):
        for _ent in targets:
            _ent.gainHP(action.get_from_stats("Heal Amount"))
        return
    var d = "Order the nanobots to heal any friend in the area"
    _add_action(ent, "Nanofield", d, shape_3x3, effect, type, stats)
    return

static func add_weapons_upgade(ent: Entity, type: int):
    var stats = {
        "Affects": "Other Friendly Units",
        "Added Damage": [1,2,3,4],
        "Cost": 2,
    }
    var effect = func (user: Entity, targets: Array, action: Action):
        for _ent in targets:
            _ent.damage_modifier += action.get_from_stats("Added Damage")
        return
    var d = "Add permanent base damage to friendly unit"
    _add_action(ent, "Weapons Upgrade", d, [], effect, type, stats)
    return

static func add_engine_upgrade(ent: Entity, type: int):
    var stats = {
        "Affects": "Other Friendly Units",
        "Added Movement": [1,2,3,4],
        "Cost": 2,
    }
    var effect = func (user: Entity, targets: Array, action: Action):
        for _ent in targets:
            _ent.movement_modifier += action.get_from_stats("Added Movement")
        return
    var d = "Make your friends move more"
    _add_action(ent, "Engine Upgrade", d, [], effect, type, stats)
    return

static func add_snipe(ent: Entity, type: int):
    var stats = {
        "Affects": "Enemy Units",
        "Additional Range": [3,3,4,4],
        "Additional Damage": [0,1,1,2],
        "Threat Gain": 1,
        "Cost": 1
    }
    var effect = func (user: Entity, targets: Array, action: Action):
        user.gainThreat(action.stats["Threat Gain"])
        for _ent in targets:
            _ent.loseHP(user.get_damage() + action.stats["Heal Amount"][action.level])
        return
    var d = "Extend the barrel and snipe"
    _add_action(ent, "Snipe", d, [], effect, type, stats)
    return

static func add_titanium_bullet(ent: Entity, type: int):
    var stats = {
        "Affects": "Enemy Units",
        "Additional Damage": [6,8,12,14],
        "Threat Gain": 3,
        "Cost": 5
    }
    var effect = func (user: Entity, targets: Array, action: Action):
        user.gainThreat(action.stats["Threat Gain"])
        for _ent in targets:
            _ent.loseHP(user.get_damage() + action.stats["Additional Damage"][action.level])
        return
    var d = ""
    _add_action(ent, "Titanium Bullet", d, [], effect, type, stats)
    return

static func _add_action(ent, display_name, description, shape, effect, action_type, stats):
    var action = Action.new()
    action.shape = shape
    action.effect = effect
    action.display_name = display_name
    action.description = description
    if action_type == ActionType.ATTACK:
        ent.attack = action
    if action_type == ActionType.ACTION1:
        ent.action1 = action
    if action_type == ActionType.ACTION2:
        ent.action2 = action
    action.stats = stats
    return
