class_name ActionFactory

static var shape_3x3 = [
        Vector2i(1,0), Vector2i(0,1), Vector2i(-1,0), Vector2i(0,-1),
        Vector2i(1,1), Vector2i(1,-1), Vector2i(-1,1), Vector2i(-1,-1)
        ]
    
static var diamond = [
        Vector2i(1,0), Vector2i(0,1), Vector2i(-1,0), Vector2i(0,-1),
        Vector2i(1,1), Vector2i(1,-1), Vector2i(-1,1), Vector2i(-1,-1),
        Vector2i(2,0), Vector2i(0,2), Vector2i(-2, 0), Vector2i(0, -2)
        ]

static func add_base_attack(ent: Entity):
    var stats = {
        "Affects": "Enemy Units",
        "Cost": 0,
        "Threat Gain": 1,
    }
    var base_effect = func (user: Entity, targets: Array, action: Action):
        var damage = user.get_damage()
        for _ent in targets:
            _ent.loseHP(damage)
            user.damage_done += damage
        return
    var d = "Deals damage to any target"
    _add_action(ent, "Normal Attack", d, [], base_effect, ActionType.ATTACK, stats)
    return

static func add_exert(ent: Entity, type: int):
    var stats = {
        "Affects": "Enemy Units",
        "Cost": 3,
        "Damage Amp": [2, 2, 3, 4],
        "Self Cripple": 3,
        "Cripple Duration": 1,
        "Threat Gain": 1,
    }
    var effect = func (user: Entity, targets: Array, action: Action):
        var damage = user.get_damage() * action.get_from_stats("Damage Amp")
        user.crippled(action.get_from_stats("Self Cripple"), action.get_from_stats("Cripple Duration"))
        for _ent in targets:
            _ent.loseHP(damage)
            user.damage_done += damage
        return
    var d = "Brutus exterts and swings hard, cripplig its own movement for next turn"
    
    _add_action(ent, "Exert", d, [], effect, type, stats)
    return

static func add_bolster(ent: Entity, type: int):
    var stats = {
        "Affects": "Self",
        "Cost": 3,
        "Shield Amount": [4, 8, 12, 16],
        "Shield Duration": 1,
        "Threat Gain": 4,
    }
    var effect = func (user: Entity, targets: Array, action: Action):
        user.shielded(action.get_from_stats("Shield Amount"), action.get_from_stats("Shield Duration"))
        return
    var d = "Bolster your defensives and attempt to goad the enemy into attacking you"
    _add_action(ent, "Bolster", d, [], effect, type, stats)
    return

static func add_oil_bomb(ent: Entity, type: int):
    var stats = {
        "Affects": "Enemy Units",
        "Cost": 2,
        "Extra Range": 2,
        "Extra Damage": [0, 1, 2, 3],
        "Cripple": [2, 2, 3, 3],
        "Cripple Duration": 1,
        "Threat Gain": 1,
    }
    var effect = func (user: Entity, targets: Array, action: Action):
        var damage = user.get_damage() + action.get_from_stats("Extra Damage") 
        for _ent in targets:
            _ent.loseHP(damage)
            _ent.crippled(action.get_from_stats("Cripple"),
                    action.get_from_stats("Cripple Duration"))
            user.damage_done += damage
        return
    var d = "Throw an oil bomb at an enemy, crippling it's movement"
    _add_action(ent, "Oil Bomb", d, [], effect, type, stats)
    return
    
static func add_lubricate(ent: Entity, type: int):
    var stats = {
        "Affects": "Self",
        "Cost": 1,
        "Extra Moves": [3,4,5,6] 
    }
    var effect = func (user: Entity, targets: Array, action: Action):
        user.moves_left += action.get_from_stats("Extra Moves")
        return
    var d = "Lubricate axles to gain extra movement for the turn"
    _add_action(ent, "Lubricate", d, [], effect, type, stats)
    return

static func add_storm(ent: Entity, type: int):
    var stats = {
        "Affects": "All Units",
        "Cost": 2,
        "Extra Damage": [2, 4, 6, 8],
        "Threat Gain": 1,
    }
    var effect = func (user: Entity, targets: Array, action: Action):
        var damage = user.get_damage() + action.get_from_stats("Extra Damage") 
        for _ent in targets:
            _ent.loseHP(damage)
            user.damage_done += damage
        return
    var d = "Create an unstable electro magnetic field and electrocute everything"
    _add_action(ent, "Storm", d, shape_3x3, effect, type, stats)
    return

static func add_static_shield(ent: Entity, type: int):
    var stats = {
        "Affects": "All Units",
        "Cost": 2,
        "Shield Amount": [3, 6, 9, 12],
        "Shield Duration": 2
    }
    var effect = func (user: Entity, targets: Array, action: Action):
        for _ent in targets:
            _ent.shielded(action.get_from_stats("Shield Amount"),
                    action.get_from_stats("Shield Duration"))
        return
    var d = "Create a stable electro magnetic field and shield everything"
    _add_action(ent, "Static Shield", d, shape_3x3, effect, type, stats)
    return

static func add_focused_repair(ent: Entity, type: int):
    var stats = {
        "Affects": "All Allied Units",
        "Cost": 2,
        "Heal Amount": [10, 16, 22, 28],
    }
    var effect = func (user: Entity, targets: Array, action: Action):
        for _ent in targets:
            _ent.gainHP(action.get_from_stats("Heal Amount"))
        return
    var d = "Summon all the nanobots to heal one ally"
    _add_action(ent, "Focused Repair", d, [], effect, type, stats)
    return

static func add_nano_field(ent: Entity, type: int):
    var stats = {
        "Affects": "All Allied Units",
        "Cost": 2,
        "Heal Amount": [5, 8, 11, 14],
    }
    var effect = func (user: Entity, targets: Array, action: Action):
        for _ent in targets:
            _ent.gainHP(action.get_from_stats("Heal Amount"))
        return
    var d = "Order the nanobots to heal any ally in the area"
    _add_action(ent, "Nanofield", d, shape_3x3, effect, type, stats)
    return

static func add_weapons_upgade(ent: Entity, type: int):
    var stats = {
        "Affects": "Other Allied Units",
        "Added Damage": [1,2,3,4],
        "Cost": 2,
    }
    var effect = func (user: Entity, targets: Array, action: Action):
        for _ent in targets:
            _ent.update_damage(action.get_from_stats("Added Damage"))
        return
    var d = "Add permanent base damage to an allied unit"
    _add_action(ent, "Weapons Upgrade", d, [], effect, type, stats)
    return

static func add_engine_upgrade(ent: Entity, type: int):
    var stats = {
        "Affects": "Other Allied Units",
        "Added Movement": [1,2,3,4],
        "Cost": 2,
    }
    var effect = func (user: Entity, targets: Array, action: Action):
        for _ent in targets:
            _ent.update_movement(action.get_from_stats("Added Movement"))
        return
    var d = "Add permanent movement to an allied unit"
    _add_action(ent, "Engine Upgrade", d, [], effect, type, stats)
    return

static func add_snipe(ent: Entity, type: int):
    var stats = {
        "Affects": "Enemy Units",
        "Extra Range": [1,2,3,4],
        "Extra Damage": [1,2,3,4],
        "Threat Gain": 1,
        "Cost": 1
    }
    var effect = func (user: Entity, targets: Array, action: Action):
        var damage = user.get_damage() + action.get_from_stats("Extra Damage")
        for _ent in targets:
            _ent.loseHP(damage)
            user.damage_done += damage
        return
    var d = "Extend the barrel and snipe em"
    _add_action(ent, "Snipe", d, [], effect, type, stats)
    return

static func add_titanium_bullet(ent: Entity, type: int):
    var stats = {
        "Affects": "Enemy Units",
        "Extra Damage": [6,12,18,24],
        "Threat Gain": 3,
        "Cost": 4
    }
    var effect = func (user: Entity, targets: Array, action: Action):
        var damage = user.get_damage() + action.get_from_stats("Extra Damage") 
        for _ent in targets:
            _ent.loseHP(damage)
            user.damage_done += damage
        return
    var d = "Fire a huge titanium bullet at an enemy"
    _add_action(ent, "Titanium Bullet", d, [], effect, type, stats)
    return

static func add_power_up(ent: Entity, type: int):
    var stats = {
        "Affects": "Other Allied Units",
        "Energy Gain": [1,2,3,4],
        "Cost": 2
    }
    var effect = func (user: Entity, targets: Array, action: Action):
        for _ent in targets:
            _ent.update_energy(action.get_from_stats("Energy Gain"))
        return
    var d = "Siphon energy to an allied unit"
    _add_action(ent, "Power Up", d, [], effect, type, stats)
    return

static func add_shock_therapy(ent: Entity, type: int):
    var stats = {
        "Affects": "All Units",
        "Health Gain": [2,4,6,8],
        "Energy Gain": 1,
        "Extra Damage": [0,1,2,3],
        "Cost": 3,
        "Threat Gain": 1
    }
    var effect = func (user: Entity, targets: Array, action: Action):
        var damage = user.get_damage() + action.get_from_stats("Extra Damage")
        for _ent in targets:
            if _ent.is_ally:
                _ent.update_energy(action.get_from_stats("Energy Gain"))
                _ent.gainHP(action.get_from_stats("Health Gain"))
            else:
                _ent.loseHP(damage)
                user.damage_done += damage
        return
    var d = "Shock an area with extreme precision, giving health and energy to allies and damaging enemies"
    _add_action(ent, "Shock Therapy", d, diamond, effect, type, stats)
    return

static func add_scatter_shot(ent: Entity, type: int):
    var stats = {
        "Affects": "All Units",
        "Extra Damage": 2,
        "Number of Attacks": [2,3,4,5],
        "Hit Chance": "33%",        
        "Cost": 2,
        "Threat Gain": 1
    }
    var effect = func (user: Entity, targets: Array, action: Action):
        var damage = user.get_damage() + action.get_from_stats("Extra Damage")
        for _ent in targets:
            if randi_range(0, 2) == 0:
                _ent.loseHP(damage)
                user.damage_done += damage
            else:
                _ent.miss()
        return
    var d = "Blanket an area with loosely targetted bullets"
    _add_action(ent, "Scatter Shot", d, diamond, effect, type, stats)
    return

static func add_spray_and_pray(ent: Entity, type: int):
    var stats = {
        "Affects": "Enemy Units",
        "Extra Damage": 2,
        "Number of Attacks": [2,3,4,5],
        "Hit Chance": "50%",
        "Cost": 2,
        "Threat Gain": 2,
    }
    var effect = func (user: Entity, targets: Array, action: Action):
        var damage = user.get_damage() + action.get_from_stats("Extra Damage")
        for _ent in targets:
            for i in range(action.get_from_stats("Number of Attacks")):
                if randi_range(0, 1) == 0:
                    _ent.loseHP(damage)
                    user.damage_done += damage
                else:
                    _ent.miss()
        return
    var d = "Fire a lot of bullets at an enemy with questionable accuracy"
    _add_action(ent, "Spray and Pray", d, [], effect, type, stats)
    return

static func add_precise_strike(ent: Entity, type: int):
    var stats = {
        "Affects": "Enemy Units",
        "Weaken": [1,2,3,4],
        "Weaken Duration": 2,
        "Cost": 1,
        "Threat Gain": 2
    }
    var effect = func (user: Entity, targets: Array, action: Action):
        var damage = user.get_damage()
        for _ent in targets:
            _ent.loseHP(damage)
            user.damage_done += damage
            _ent.weakened(action.get_from_stats("Weaken"), action.get_from_stats("Weaken Damage"))
        return
    var d = "A precise strike that weakens the enemy, causing them to take more damage"
    _add_action(ent, "Precise Strike", d, [], effect, type, stats)
    return

static func add_robo_punch(ent: Entity, type: int):
    var stats = {
        "Affects": "Enemy Units",
        "Damage Amp": [2,3,4,5],
        "Cost": 5,
        "Threat Gain": 3
    }
    var effect = func (user: Entity, targets: Array, action: Action):
        var damage = user.get_damage() * action.get_from_stats("Damage Amp")
        for _ent in targets:
            _ent.loseHP(damage)
            user.damage_done += damage
        return
    var d = "An extremely high energy powered punch"
    _add_action(ent, "Robo Punch!", d, [], effect, type, stats)
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
