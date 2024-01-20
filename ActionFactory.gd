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
        "Affects": TargetTypes.ENEMIES,
        "Cost": 0,
        "Threat Gain": 1,
    }
    var base_effect = func (user: Entity, targets: Array, action: Action):
        var damage = user.get_damage()
        for _ent in targets:
            _ent.loseHP(damage)
            user.damage_done += _ent.damage_preview(damage)
        return
    var d = "Deals damage to any target"
    _add_action(ent, "Normal Attack", d, [], base_effect, ActionType.ATTACK, stats, "res://Effects/explosion_yellow.tscn")
    return

static func add_exert(ent: Entity, type: int):
    var stats = {
        "Affects": TargetTypes.ENEMIES,
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
            user.damage_done += _ent.damage_preview(damage)
        return
    var d = "Exterts and swings hard, cripplig its own movement for next turn"
    
    _add_action(ent, "Exert", d, [], effect, type, stats, "res://Effects/explosion_yellow.tscn")
    return

static func add_sturdy_stance(ent: Entity, type: int):
    var stats = {
        "Affects": TargetTypes.SELF,
        "Cost": 3,
        "Shield Amount": [5, 10, 15, 20],
        "Threat Gain": 4,
    }
    var effect = func (user: Entity, targets: Array, action: Action):
        user.shielded(action.get_from_stats("Shield Amount"), action.get_from_stats("Shield Duration"))
        return
    var d = "Bolster your defensives and taunt enemies into attacking you"
    _add_action(ent, "Sturdy Stance", d, [], effect, type, stats, "res://Effects/upgrade_effect.tscn")
    return

static func add_flying_barb_stance(ent: Entity, type: int):
    var stats = {
        "Affects": TargetTypes.SELF,
        "Reflected Damage": "1x",
        "Shield Amount": 10,
        "Threat Gain": 5,
    }
    var effect = func (user: Entity, targets: Array, action: Action):
        user.shielded(action.get_from_stats("Shield Amount"), 1)
        return
    var d = "Taunt enemies, then deal the damage back to ALL enemies"
    _add_action(ent, "Flying Barbs Stance", d, [], effect, type, stats, "res://Effects/upgrade_effect.tscn")
    return

static func add_oil_bomb(ent: Entity, type: int):
    var stats = {
        "Affects": TargetTypes.ENEMIES,
        "Cost": 3,
        "Extra Range": 2,
        "Extra Damage": [0, 1, 2, 3],
        "Cripple": [1, 2, 3, 4],
        "Cripple Duration": 1,
        "Threat Gain": 1,
    }
    var effect = func (user: Entity, targets: Array, action: Action):
        var damage = user.get_damage() + action.get_from_stats("Extra Damage") 
        for _ent in targets:
            _ent.loseHP(damage)
            _ent.crippled(action.get_from_stats("Cripple"),
                    action.get_from_stats("Cripple Duration"))
            user.damage_done += _ent.damage_preview(damage)
        return
    var d = "Throw an oil bomb at an enemy, crippling it's movement"
    _add_action(ent, "Oil Bomb", d, [], effect, type, stats, "res://Effects/explosion_yellow.tscn")
    return

static func add_winding_strike(ent: Entity, type: int):
    var stats = {
        "Affects": "Enemy Units",
        "Damage per Tile Moved": 3,
    }
    var effect = func (user: Entity, targets: Array, action: Action):
        for _ent in targets:
            _ent.loseHP((user.get_movement() - user.moves_left)*3)
        return
    var d = "Deals damage based on tiles moved this turn by the user"
    _add_action(ent, "Winding Strike", d, [], effect, type, stats, "res://Effects/explosion_yellow.tscn")
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
    _add_action(ent, "Lubricate", d, [], effect, type, stats, "res://Effects/upgrade_effect.tscn")
    return

static func add_storm(ent: Entity, type: int):
    var stats = {
        "Affects": TargetTypes.ENEMIES,
        "Cost": 2,
        "Extra Damage": [2, 4, 6, 8],
        "Threat Gain": 2,
    }
    var effect = func (user: Entity, targets: Array, action: Action):
        var damage = user.get_damage() + action.get_from_stats("Extra Damage") 
        for _ent in targets:
            _ent.loseHP(damage)
            user.damage_done += _ent.damage_preview(damage)
        return
    var d = "Deal damage in a square area"
    _add_action(ent, "Storm", d, shape_3x3, effect, type, stats, "res://Effects/explosion_yellow.tscn")
    return

static func add_thunderous_wrath(ent: Entity, type: int):
    var stats = {
        "Affects": TargetTypes.ALL_ENEMIES,
        "Extra Damage": 8,
    }
    var effect = func (user: Entity, targets: Array, action: Action):
        var damage = user.get_damage() + action.get_from_stats("Extra Damage") 
        for _ent in targets:
            _ent.loseHP(damage)
            user.damage_done += _ent.damage_preview(damage)
        return
    var d = "Deal damage to every enemy unit"
    _add_action(ent, "Thunderous Wrath", d, shape_3x3, effect, type, stats, "res://Effects/explosion_yellow.tscn")
    return

static func add_static_shield(ent: Entity, type: int):
    var stats = {
        "Affects": "All Units",
        "Cost": 2,
        "Shield Amount": [3, 6, 9, 10],
        "Shield Duration": 1
    }
    var effect = func (user: Entity, targets: Array, action: Action):
        for _ent in targets:
            _ent.shielded(action.get_from_stats("Shield Amount"),
                    action.get_from_stats("Shield Duration"))
        return
    var d = "Create a stable electro magnetic field and shield everything"
    _add_action(ent, "Static Shield", d, shape_3x3, effect, type, stats, "res://Effects/upgrade_effect.tscn")
    return

static func add_focused_repair(ent: Entity, type: int):
    var stats = {
        "Affects": "Allied Units",
        "Cost": 2,
        "Heal Amount": [6, 10, 14, 18],
    }
    var effect = func (user: Entity, targets: Array, action: Action):
        for _ent in targets:
            _ent.gainHP(action.get_from_stats("Heal Amount"))
        return
    var d = "Heal one ally"
    _add_action(ent, "Focused Repair", d, [], effect, type, stats, "res://Effects/upgrade_effect.tscn")
    return

static func add_swarm_of_pain(ent: Entity, type: int):
    var stats = {
        "Affects": TargetTypes.ENEMIES,
        "Damage": "2x Max Health",
    }
    var effect = func (user: Entity, targets: Array, action: Action):
        for _ent in targets:
            _ent.gainHP(user.max_health * 2)
        return
    var d = "Summon all the nanobots to attack a single unit"
    _add_action(ent, "Swarm of Pain", d, [], effect, type, stats, "res://Effects/explosion_yellow.tscn")
    return

static func add_nano_field(ent: Entity, type: int):
    var stats = {
        "Affects": "All Allied Units",
        "Cost": 2,
        "Heal Amount": [3, 5, 7, 9],
    }
    var effect = func (user: Entity, targets: Array, action: Action):
        for _ent in targets:
            _ent.gainHP(action.get_from_stats("Heal Amount"))
        return
    var d = "Order the nanobots to heal any ally in the area"
    _add_action(ent, "Nanofield", d, shape_3x3, effect, type, stats, "res://Effects/upgrade_effect.tscn")
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
    _add_action(ent, "Weapons Upgrade", d, [], effect, type, stats, "res://Effects/upgrade_effect.tscn")
    return

static func add_auto_turret_3000(ent: Entity, type: int):
    var stats = {
        "Affects": TargetTypes.EMPTY,
        "Turret Damage": 10,
        "Turret Initiative": 15,
        "Turret Movement": 0,
        "Turret HP": 5,
        "Turret HP Loss Per Turn": 1
    }
    var effect = func (user: Entity, targets: Array, action: Action):
        action.spawn = EntityFactory.create_auto_turret_3000()
        return
    var d = "Deploy the Auto Turret 3000, a powerful turret that slowly deteriorates"
    _add_action(ent, "Auto Turret 3000", d, [], effect, type, stats, "res://Effects/upgrade_effect.tscn")
    return

static func add_engine_upgrade(ent: Entity, type: int):
    var stats = {
        "Affects": "Other Allied Units",
        "Added Movement": [1,2,2,3],
        "Cost": 2,
    }
    var effect = func (user: Entity, targets: Array, action: Action):
        for _ent in targets:
            _ent.update_movement(action.get_from_stats("Added Movement"))
        return
    var d = "Add permanent movement to an allied unit"
    _add_action(ent, "Engine Upgrade", d, [], effect, type, stats, "res://Effects/upgrade_effect.tscn")
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
            user.damage_done += _ent.damage_preview(damage)
        return
    var d = "Extend the barrel and snipe em"
    _add_action(ent, "Snipe", d, [], effect, type, stats, "res://Effects/explosion_yellow.tscn")
    return

static func add_god_shot(ent: Entity, type: int):
    var stats = {
        "Affects": "Enemy Units",
        "Extra Damage": 25,
        "Extra Range": 99,
    }
    var effect = func (user: Entity, targets: Array, action: Action):
        var damage = user.get_damage() + action.get_from_stats("Extra Damage") 
        for _ent in targets:
            _ent.loseHP(damage)
            user.damage_done += _ent.damage_preview(damage)
        return
    var d = "Shoot with near unlimited range doing critical damage"
    _add_action(ent, "God Shot", d, [], effect, type, stats, "res://Effects/explosion_yellow.tscn")
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
    _add_action(ent, "Siphon Energy", d, [], effect, type, stats, "res://Effects/upgrade_effect.tscn")
    return

static func add_ultimate_shiphon(ent: Entity, type: int):
    var stats = {
        "Affects": "Other Allied Units",
    }
    var effect = func (user: Entity, targets: Array, action: Action):
        for _ent in targets:
            _ent.ultimate_used = false
            # TODO Add Text
        return
    var d = "Siphon ultimate energy to an allied unit, allowing their ultimate to be used again"
    _add_action(ent, "Siphon Energy", d, [], effect, type, stats, "res://Effects/upgrade_effect.tscn")
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
                user.damage_done += _ent.damage_preview(damage)
        return
    var d = "Shock an area with extreme precision, giving health and energy to allies and damaging enemies"
    _add_action(ent, "Shock Therapy", d, diamond, effect, type, stats, "res://Effects/explosion_yellow.tscn")
    return

static func add_bullet_rain(ent: Entity, type: int):
    var stats = {
        "Affects": "All Units",
        "Extra Damage": 2,
        "Number of Attacks": 6,
        "Hit Chance": "50%",        
    }
    var effect = func (user: Entity, targets: Array, action: Action):
        var damage = user.get_damage() + action.get_from_stats("Extra Damage")
        for _ent in targets:
            for i in range(action.get_from_stats("Number of Attacks")):
                if randi_range(0, 1) == 0:
                    _ent.loseHP(damage)
                    user.damage_done += _ent.damage_preview(damage)
                else:
                    _ent.miss()
        return
    var d = "Blanket an area with many bullets"
    _add_action(ent, "Bullet Rain", d, diamond, effect, type, stats, "res://Effects/explosion_yellow.tscn")
    return

static func add_spray_and_pray(ent: Entity, type: int):
    var stats = {
        "Affects": "Enemy Units",
        "Extra Damage": 1,
        "Number of Attacks": [2,3,4,5],
        "Hit Chance": "50%",
        "Cost": 2,
        "Threat Gain": 3,
    }
    var effect = func (user: Entity, targets: Array, action: Action):
        var damage = user.get_damage() + action.get_from_stats("Extra Damage")
        for _ent in targets:
            for i in range(action.get_from_stats("Number of Attacks")):
                if randi_range(0, 1) == 0:
                    _ent.loseHP(damage)
                    user.damage_done += _ent.damage_preview(damage)
                else:
                    _ent.miss()
        return
    var d = "Fire a lot of bullets at an enemy with questionable accuracy"
    _add_action(ent, "Spray and Pray", d, [], effect, type, stats, "res://Effects/explosion_yellow.tscn")
    return

static func add_precise_strike(ent: Entity, type: int):
    var stats = {
        "Affects": "Enemy Units",
        "Weaken": [2,3,4,5],
        "Weaken Duration": 2,
        "Cost": 1,
        "Threat Gain": 2
    }
    var effect = func (user: Entity, targets: Array, action: Action):
        var damage = user.get_damage()
        for _ent in targets:
            _ent.loseHP(damage)
            user.damage_done += _ent.damage_preview(damage)
            _ent.weakened(action.get_from_stats("Weaken"), action.get_from_stats("Weaken Duration"))
        return
    var d = "A precise strike that weakens the enemy, causing them to take more damage"
    _add_action(ent, "Precise Strike", d, [], effect, type, stats, "res://Effects/explosion_yellow.tscn")
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
            user.damage_done += _ent.damage_preview(damage)
        return
    var d = "An extremely high energy powered punch"
    _add_action(ent, "Robo Punch!", d, [], effect, type, stats, "res://Effects/explosion_yellow.tscn")
    return

static func add_KO_punch(ent: Entity, type: int):
    var stats = {
        "Affects": "Enemy Units",
        "Damage Amp": 2,
        "Turns Skipped": 1,
    }
    var effect = func (user: Entity, targets: Array, action: Action):
        var damage = user.get_damage() * action.get_from_stats("Damage Amp")
        for _ent in targets:
            _ent.loseHP(damage)
            user.damage_done += _ent.damage_preview(damage)
            _ent.skip_next_turn = true
        return
    var d = "Punch so good the enemy skips it's next turn"
    _add_action(ent, "Robo Punch!", d, [], effect, type, stats, "res://Effects/explosion_yellow.tscn")
    return

static func add_double_strike(ent: Entity, type: int):
    var stats = {
        "Affects": "Enemy Units",
        "Number of Attacks": 2,
        "Extra Damage": [-1, 0, 1, 2],
        "Cost": 2,
        "Threat Gain": 2
    }
    var effect = func (user: Entity, targets: Array, action: Action):
        var damage = user.get_damage() + action.get_from_stats("Extra Damage")
        for _ent in targets:
            _ent.loseHP(damage)
            _ent.loseHP(damage)
            user.damage_done += _ent.damage_preview(damage)
            user.damage_done += _ent.damage_preview(damage)
        return
    var d = "Hit them with the good ol' one-two"
    _add_action(ent, "Double Strike", d, [], effect, type, stats, "res://Effects/explosion_yellow.tscn")
    return

static func add_bootleg_upgrades(ent: Entity, type: int):
    var stats = {
        "Affects": "Self",
        "Added Movement": "-1 / 1",
        "Added Initiative": "-1 / 1",
        "Added Damage": "-1 / 1",
        "Added Armor": "-1 / 1",
        "Chance for each Upgrade": ["50%", "60%", "70%", "80%"],
        "Cost": 1,
    }
    var effect = func (user: Entity, targets: Array, action: Action):
        var l = action.level + 4
        
        if randi_range(1, 10) > l:
            user.update_movement(-1)
        else:
            user.update_movement(1)
        
        if randi_range(1, 10) > l:
            user.update_initiative(-1)
        else:
            user.update_initiative(1)
        
        if randi_range(1, 10) > l:
            user.update_damage(-1)
        else:
            user.update_damage(1)
        
        if randi_range(1, 10) > l:
            user.update_armor(-1)
        else:
            user.update_armor(1)
        return
    var d = "Put some bootleg parts on, resulting in added or removed stats"
    _add_action(ent, "Bootleg Upgrades", d, [], effect, type, stats, "res://Effects/upgrade_effect.tscn")
    return

static func add_battlefield_transfer(ent: Entity, type: int):
    var stats = {
        "Affects": "Other Allied Units",
    }
    var effect = func (user: Entity, targets: Array, action: Action):
        for _ent in targets:
            _ent.update_damage(user.damage_modifier)
            _ent.update_initiative(user.initiative_modifier)
            _ent.update_movement(user.movement_modifier)
            _ent.update_armor(user.armor_modifier)
            user.update_damage(-user.damage_modifier)
            user.update_initiative(-user.initiative_modifier)
            user.update_movement(-user.movement_modifier)
            user.update_armor(-user.armor_modifier)
        return
    var d = "Transfer all movement, damage, armor, and initiative upgrades and downgrades to another allied unit"
    _add_action(ent, "Battlefield Transfer", d, [], effect, type, stats, "res://Effects/upgrade_effect.tscn")
    return

static func _add_action(ent, display_name, description, shape, effect, action_type, stats, animation_path = ""):
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
        action.level = 0
    action.type = action_type
    action.stats = stats
    action.animation_path = animation_path
    return
