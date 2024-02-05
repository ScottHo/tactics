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
static var cone = [
        Vector2i(0,1), Vector2i(1,0), Vector2i(0,-1)
        ]
static var straight = [
        Vector2i(1,0), Vector2i(2,0)
        ]
static var cone_reverse = [
        Vector2i(1,1), Vector2i(1,0), Vector2i(1,-1)
        ]

static func add_base_attack(ent: Entity):
    var stats = {
        "Affects": TargetTypes.ANY_OTHER,
        "Cost": 0,
        "Threat Gain": 1,
    }
    var base_effect = func (_user: Entity, _targets: Array, _action: Action):
        var damage = _user.get_damage()
        for _ent in _targets:
            if randf() < _user.crit_chance:
                damage += _user.get_damage()
                _ent.custom_text("Crit!", Color.YELLOW)
            if _user.heal_attack:
                _ent.gainHP(damage)
            else:
                _user.damage_done += _ent.damage_preview(damage)        
                _ent.loseHP(damage)
            if randf() < _user.armor_break_chance:
                _ent.update_armor(-1)
        return
    var d = "Deals damage to any other target"
    var action := _add_action(ent, "Normal Attack", d, [], base_effect, ActionType.ATTACK, stats, "res://Effects/explosion_yellow.tscn")
    action.target_animation = TargetAnimations.HIT
    return

static func add_weaken(ent: Entity, type: int):
    var stats = {
        "Affects": "Enemy Units",
        "Weaken": 1,
        "Weaken Duration": 2,
        "Cost": 2,
        "Threat Gain": 2
    }
    var effect = func (_user: Entity, _targets: Array, _action: Action):
        var damage = _user.get_damage()
        for _ent in _targets:
            _user.damage_done += _ent.damage_preview(damage)            
            _ent.loseHP(damage)
            _ent.weakened(_action.get_from_stats("Weaken"), _action.get_from_stats("Weaken Duration"))
            _ent.hit_animation()
        return
    var d = "Weaken the enemy, reducing it's armor temporarily. Stats can be modified temporarily, or last \
through the mission depending on the ability."
    var action = _add_action(ent, "Weaken", d, [], effect, type, stats, "res://Effects/explosion_yellow.tscn")
    action.target_animation = TargetAnimations.HIT
    return

static func add_double_shot(ent: Entity, type: int):
    var stats = {
        "Affects": "Enemy Units",
        "Number of Attacks": 2,
        "Threat Gain": 2
    }
    var effect = func (_user: Entity, _targets: Array, _action: Action):
        var damage = _user.get_damage()
        for _ent in _targets:
            _user.damage_done += _ent.damage_preview(damage)            
            _ent.loseHP(damage)
            _user.damage_done += _ent.damage_preview(damage)            
            _ent.loseHP(damage)
            _ent.hit_animation()
        return
    var d = "Shoot twice. Ultimate abilities can only be used once per mission"
    var action := _add_action(ent, "Double Shot", d, [], effect, type, stats, "res://Effects/explosion_yellow.tscn")
    action.target_animation = TargetAnimations.HIT
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
    var effect = func (_user: Entity, _targets: Array, _action: Action):
        var damage = _user.get_damage() * _action.get_from_stats("Damage Amp")
        _user.crippled(_action.get_from_stats("Self Cripple"), _action.get_from_stats("Cripple Duration"))
        for _ent in _targets:
            _ent.loseHP(damage)
            _user.damage_done += _ent.damage_preview(damage)
            _ent.hit_animation()
        return
    var d = "Exterts and swings hard, cripplig its own movement for next turn"
    
    var action := _add_action(ent, "Exert", d, [], effect, type, stats, "res://Effects/explosion_yellow.tscn")
    action.target_animation = TargetAnimations.HIT
    return

static func add_sturdy_stance(ent: Entity, type: int):
    var stats = {
        "Affects": TargetTypes.SELF,
        "Cost": 3,
        "Shield Amount": [4, 8, 12, 16],
        "Threat Gain": 4,
    }
    var effect = func (_user: Entity, _targets: Array, _action: Action):
        _user.shielded(_action.get_from_stats("Shield Amount"))
        return
    var d = "Create a shield and taunt enemies into attacking you"
    var action := _add_action(ent, "Sturdy Stance", d, [], effect, type, stats, "res://Effects/upgrade_effect.tscn")
    action.highlight_style = Highlights.HEAL
    return

static func add_flying_barb_stance(ent: Entity, type: int):
    var stats = {
        "Affects": TargetTypes.SELF,
        "Reflected Damage": "100%",
        "Health Gain": 20,
        "Shield Amount": 10,
        "Threat Gain": 5,
    }
    var effect = func (_user: Entity, _targets: Array, _action: Action):
        _user.gainHP(20)
        _user.shielded(_action.get_from_stats("Shield Amount"))
        _user.gainThreat(5)
        _user.thorns_all = true
        return
    var d = "Gain 5 threat. Until next turn, deal any damage back to ALL enemies from enemy Normal Attacks, before armor"
    var action := _add_action(ent, "Flying Barbs Stance", d, [], effect, type, stats, "res://Effects/upgrade_effect.tscn")
    action.highlight_style = Highlights.HEAL
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
    var effect = func (_user: Entity, _targets: Array, _action: Action):
        var damage = _user.get_damage() + _action.get_from_stats("Extra Damage") 
        for _ent in _targets:
            _user.damage_done += _ent.damage_preview(damage)            
            _ent.loseHP(damage)
            _ent.crippled(_action.get_from_stats("Cripple"),
                    _action.get_from_stats("Cripple Duration"))
        return
    var d = "Deal damage at extra range, crippling it's movement"
    var action := _add_action(ent, "Oil Bomb", d, [], effect, type, stats, "res://Effects/explosion_yellow.tscn")
    action.target_animation = TargetAnimations.HIT
    return

static func add_winding_strike(ent: Entity, type: int):
    var stats = {
        "Affects": "Enemy Units",
        "Damage per Tile Moved": 3,
    }
    var effect = func (_user: Entity, _targets: Array, _action: Action):
        var damage = (_user.get_movement() - _user.moves_left)*3        
        for _ent in _targets:
            _user.damage_done += _ent.damage_preview(damage)
            _ent.loseHP(damage)
        return
    var d = "Deals damage based on tiles moved this turn by the user"
    var action := _add_action(ent, "Winding Strike", d, [], effect, type, stats, "res://Effects/explosion_yellow.tscn")
    action.target_animation = TargetAnimations.HIT
    return
    
static func add_lubricate(ent: Entity, type: int):
    var stats = {
        "Affects": "Self",
        "Cost": 1,
        "Extra Moves": [3,4,5,6] 
    }
    var effect = func (_user: Entity, _targets: Array, _action: Action):
        _user.moves_left += _action.get_from_stats("Extra Moves")
        return
    var d = "Lubricate axles to gain extra movement for the turn"
    var action := _add_action(ent, "Lubricate", d, [], effect, type, stats, "res://Effects/upgrade_effect.tscn")
    action.highlight_style = Highlights.HEAL
    return

static func add_storm(ent: Entity, type: int):
    var stats = {
        "Affects": TargetTypes.ENEMIES,
        "Cost": 2,
        "Extra Damage": [2, 4, 6, 8],
        "Threat Gain": 2,
    }
    var effect = func (_user: Entity, _targets: Array, _action: Action):
        var damage = _user.get_damage() + _action.get_from_stats("Extra Damage") 
        for _ent in _targets:
            _user.damage_done += _ent.damage_preview(damage)
            _ent.loseHP(damage)
        return
    var d = "Deal damage in a square area"
    var action := _add_action(ent, "Storm", d, shape_3x3, effect, type, stats, "res://Effects/explosion_yellow.tscn")
    action.target_animation = TargetAnimations.HIT
    return

static func add_thunderous_wrath(ent: Entity, type: int):
    var stats = {
        "Affects": TargetTypes.ALL_ENEMIES,
        "Extra Damage": 8,
    }
    var effect = func (_user: Entity, _targets: Array, _action: Action):
        var damage = _user.get_damage() + _action.get_from_stats("Extra Damage") 
        for _ent in _targets:
            _user.damage_done += _ent.damage_preview(damage)            
            _ent.loseHP(damage)
        return
    var d = "Deal damage to every enemy unit"
    var action := _add_action(ent, "Thunderous Wrath", d, [], effect, type, stats, "res://Effects/explosion_yellow.tscn")
    action.target_animation = TargetAnimations.HIT
    return

static func add_static_shield(ent: Entity, type: int):
    var stats = {
        "Affects": "All Units",
        "Cost": 2,
        "Shield Amount": [3, 6, 9, 10],
    }
    var effect = func (_user: Entity, _targets: Array, _action: Action):
        for _ent in _targets:
            _ent.shielded(_action.get_from_stats("Shield Amount"))
        return
    var d = "Create a stable electro magnetic field and shield everything"
    var action := _add_action(ent, "Static Shield", d, shape_3x3, effect, type, stats, "res://Effects/upgrade_effect.tscn")
    action.highlight_style = Highlights.HEAL
    return

static func add_focused_repair(ent: Entity, type: int):
    var stats = {
        "Affects": "Allied Units",
        "Cost": 2,
        "Heal Amount": [6, 10, 14, 18],
    }
    var effect = func (_user: Entity, _targets: Array, _action: Action):
        for _ent in _targets:
            _ent.gainHP(_action.get_from_stats("Heal Amount"))
        return
    var d = "Heal one ally"
    var action := _add_action(ent, "Focused Repair", d, [], effect, type, stats, "res://Effects/upgrade_effect.tscn")
    action.highlight_style = Highlights.HEAL
    action.target_animation = TargetAnimations.BUFF
    return

static func add_swarm_of_pain(ent: Entity, type: int):
    var stats = {
        "Affects": TargetTypes.ENEMIES,
        "Damage": "2x Current Health",
    }
    var effect = func (_user: Entity, _targets: Array, _action: Action):
        var damage = _user.health * 2
        for _ent in _targets:
            _user.damage_done += _ent.damage_preview(damage)
            _ent.loseHP(damage)
        return
    var d = "Deal damage based on Nano-Nano's current health to a single unit"
    var action := _add_action(ent, "Swarm of Pain", d, [], effect, type, stats, "res://Effects/explosion_yellow.tscn")
    action.target_animation = TargetAnimations.HIT
    return

static func add_nano_field(ent: Entity, type: int):
    var stats = {
        "Affects": "Allied Units",
        "Cost": 2,
        "Heal Amount": [3, 5, 7, 9],
    }
    var effect = func (_user: Entity, _targets: Array, _action: Action):
        for _ent in _targets:
            _ent.gainHP(_action.get_from_stats("Heal Amount"))
        return
    var d = "Order the nanobots to heal any ally in the area"
    var action := _add_action(ent, "Nanofield", d, shape_3x3, effect, type, stats, "res://Effects/upgrade_effect.tscn")
    action.highlight_style = Highlights.HEAL
    action.target_animation = TargetAnimations.BUFF
    return

static func add_weapons_upgade(ent: Entity, type: int):
    var stats = {
        "Affects": "Other Allied Units",
        "Added Damage": [1,2,3,4],
        "Cost": 2,
    }
    var effect = func (_user: Entity, _targets: Array, _action: Action):
        for _ent in _targets:
            _ent.update_damage(_action.get_from_stats("Added Damage"))
        return
    var d = "Add permanent base damage to an allied unit"
    var action := _add_action(ent, "Weapons Upgrade", d, [], effect, type, stats, "res://Effects/upgrade_effect.tscn")
    action.highlight_style = Highlights.HEAL
    action.target_animation = TargetAnimations.BUFF
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
    var effect = func (_user: Entity, _targets: Array, _action: Action):
        _action.spawn = EntityFactory.create_auto_turret_3000()
        return
    var d = "Deploy the Auto Turret 3000, a powerful but fragile turret that slowly deteriorates"
    var action := _add_action(ent, "Auto Turret 3000", d, [], effect, type, stats, "res://Effects/upgrade_effect.tscn")
    action.highlight_style = Highlights.SPAWN
    return

static func add_engine_upgrade(ent: Entity, type: int):
    var stats = {
        "Affects": "Other Allied Units",
        "Added Movement": [1,2,2,3],
        "Cost": 2,
    }
    var effect = func (_user: Entity, _targets: Array, _action: Action):
        for _ent in _targets:
            _ent.update_movement(_action.get_from_stats("Added Movement"))
        return
    var d = "Add permanent movement to an allied unit"
    var action := _add_action(ent, "Engine Upgrade", d, [], effect, type, stats, "res://Effects/upgrade_effect.tscn")
    action.highlight_style = Highlights.HEAL
    action.target_animation = TargetAnimations.BUFF
    return

static func add_snipe(ent: Entity, type: int):
    var stats = {
        "Affects": "Enemy Units",
        "Extra Range": [1,2,3,4],
        "Extra Damage": [1,2,3,4],
        "Threat Gain": 1,
        "Cost": 1
    }
    var effect = func (_user: Entity, _targets: Array, _action: Action):
        var damage = _user.get_damage() + _action.get_from_stats("Extra Damage")
        for _ent in _targets:
            _user.damage_done += _ent.damage_preview(damage)            
            _ent.loseHP(damage)
        return
    var d = "Extend the barrel and snipe em"
    var action := _add_action(ent, "Snipe", d, [], effect, type, stats, "res://Effects/explosion_yellow.tscn")
    action.target_animation = TargetAnimations.HIT
    return

static func add_god_shot(ent: Entity, type: int):
    var stats = {
        "Affects": "Enemy Units",
        "Extra Damage": 25,
        "Extra Range": 99,
    }
    var effect = func (_user: Entity, _targets: Array, _action: Action):
        var damage = _user.get_damage() + _action.get_from_stats("Extra Damage") 
        for _ent in _targets:
            _user.damage_done += _ent.damage_preview(damage)            
            _ent.loseHP(damage)
        return
    var d = "Shoot with near unlimited range doing critical damage"
    var action := _add_action(ent, "God Shot", d, [], effect, type, stats, "res://Effects/explosion_yellow.tscn")
    action.target_animation = TargetAnimations.HIT
    return

static func add_power_up(ent: Entity, type: int):
    var stats = {
        "Affects": "Other Allied Units",
        "Energy Gain": [1,2,3,4],
        "Cost": 3
    }
    var effect = func (_user: Entity, _targets: Array, _action: Action):
        for _ent in _targets:
            _ent.update_energy(_action.get_from_stats("Energy Gain"))
        return
    var d = "Siphon energy to an allied unit"
    var action := _add_action(ent, "Siphon Energy", d, [], effect, type, stats, "res://Effects/upgrade_effect.tscn")
    action.highlight_style = Highlights.HEAL
    action.target_animation = TargetAnimations.BUFF
    return

static func add_ultimate_shiphon(ent: Entity, type: int):
    var stats = {
        "Affects": "Other Allied Units",
    }
    var effect = func (_user: Entity, _targets: Array, _action: Action):
        for _ent in _targets:
            _ent.ultimate_used = false
            _ent.action2.ultimate_used = false
            _ent.custom_text("Ult Recharged", Color.GREEN)
        return
    var d = "Siphon ultimate energy to an allied unit, allowing their ultimate to be used again"
    var action := _add_action(ent, "Siphon Ultimate", d, [], effect, type, stats, "res://Effects/upgrade_effect.tscn")
    action.highlight_style = Highlights.HEAL
    action.target_animation = TargetAnimations.BUFF
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
    var effect = func (_user: Entity, _targets: Array, _action: Action):
        var damage = _user.get_damage() + _action.get_from_stats("Extra Damage")
        for _ent in _targets:
            if _ent.is_ally:
                _ent.update_energy(_action.get_from_stats("Energy Gain"))
                _ent.gainHP(_action.get_from_stats("Health Gain"))
            else:
                _user.damage_done += _ent.damage_preview(damage)                
                _ent.loseHP(damage)
        return
    var d = "Shock an area with extreme precision, giving health and energy to allies and damaging enemies"
    _add_action(ent, "Shock Therapy", d, diamond, effect, type, stats, "res://Effects/explosion_yellow.tscn")
    return

static func add_bullet_rain(ent: Entity, type: int):
    var stats = {
        "Affects": "All Units",
        "Extra Damage": 1,
        "Number of Attacks": 5,
        "Hit Chance": "66.66%",
    }
    var effect = func (_user: Entity, _targets: Array, _action: Action):
        var damage = _user.get_damage() + _action.get_from_stats("Extra Damage")
        for _ent in _targets:
            for i in range(_action.get_from_stats("Number of Attacks")):
                if randi_range(0, 2) < 2:
                    _user.damage_done += _ent.damage_preview(damage)                    
                    _ent.loseHP(damage)
                else:
                    _ent.miss()
        return
    var d = "Blanket an area with many bullets"
    var action := _add_action(ent, "Bullet Rain", d, diamond, effect, type, stats, "res://Effects/explosion_yellow.tscn")
    action.target_animation = TargetAnimations.HIT
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
    var effect = func (_user: Entity, _targets: Array, _action: Action):
        var damage = _user.get_damage() + _action.get_from_stats("Extra Damage")
        for _ent in _targets:
            for i in range(_action.get_from_stats("Number of Attacks")):
                if randi_range(0, 1) == 0:
                    _user.damage_done += _ent.damage_preview(damage)                    
                    _ent.loseHP(damage)
                else:
                    _ent.miss()
        return
    var d = "Fire a lot of bullets at an enemy with questionable accuracy"
    var action := _add_action(ent, "Spray and Pray", d, [], effect, type, stats, "res://Effects/explosion_yellow.tscn")
    action.target_animation = TargetAnimations.HIT
    return

static func add_precise_strike(ent: Entity, type: int):
    var stats = {
        "Affects": "Enemy Units",
        "Weaken": [2,3,4,5],
        "Weaken Duration": 2,
        "Cost": 1,
        "Threat Gain": 2
    }
    var effect = func (_user: Entity, _targets: Array, _action: Action):
        var damage = _user.get_damage()
        for _ent in _targets:
            _user.damage_done += _ent.damage_preview(damage)            
            _ent.loseHP(damage)
            _ent.weakened(_action.get_from_stats("Weaken"), _action.get_from_stats("Weaken Duration"))
        return
    var d = "A precise strike that weakens the enemy, causing them to take more damage"
    var action := _add_action(ent, "Precise Strike", d, [], effect, type, stats, "res://Effects/explosion_yellow.tscn")
    action.target_animation = TargetAnimations.HIT
    return

static func add_robo_punch(ent: Entity, type: int):
    var stats = {
        "Affects": "Enemy Units",
        "Damage Amp": [2,3,4,5],
        "Cost": 5,
        "Threat Gain": 3
    }
    var effect = func (_user: Entity, _targets: Array, _action: Action):
        var damage = _user.get_damage() * _action.get_from_stats("Damage Amp")
        for _ent in _targets:
            _user.damage_done += _ent.damage_preview(damage)            
            _ent.loseHP(damage)
        return
    var d = "An extremely high energy powered punch"
    var action := _add_action(ent, "Robo Punch", d, [], effect, type, stats, "res://Effects/explosion_yellow.tscn")
    action.target_animation = TargetAnimations.HIT
    return

static func add_KO_punch(ent: Entity, type: int):
    var stats = {
        "Affects": "Enemy Units",
        "Damage Amp": 2,
        "Turns Skipped": 1,
    }
    var effect = func (_user: Entity, _targets: Array, _action: Action):
        var damage = _user.get_damage() * _action.get_from_stats("Damage Amp")
        for _ent in _targets:
            _user.damage_done += _ent.damage_preview(damage)            
            _ent.loseHP(damage)
            _ent.skip_next_turn = true
        return
    var d = "Knockout the enemy, skipping it's next turn"
    var action := _add_action(ent, "Knockout Punch", d, [], effect, type, stats, "res://Effects/explosion_yellow.tscn")
    action.target_animation = TargetAnimations.HIT
    return

static func add_double_strike(ent: Entity, type: int):
    var stats = {
        "Affects": "Enemy Units",
        "Number of Attacks": 2,
        "Extra Damage": [-1, 0, 1, 2],
        "Cost": 2,
        "Threat Gain": 2
    }
    var effect = func (_user: Entity, _targets: Array, _action: Action):
        var damage = _user.get_damage() + _action.get_from_stats("Extra Damage")
        for _ent in _targets:
            _user.damage_done += _ent.damage_preview(damage)
            _user.damage_done += _ent.damage_preview(damage)
            _ent.loseHP(damage)
            _ent.loseHP(damage)
        return
    var d = "Hit them with the good ol' one-two"
    var action := _add_action(ent, "Double Strike", d, [], effect, type, stats, "res://Effects/explosion_yellow.tscn")
    action.target_animation = TargetAnimations.HIT
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
    var effect = func (_user: Entity, _targets: Array, _action: Action):
        var l = _action.level + 4
        
        if randi_range(1, 10) > l:
            _user.update_movement(-1)
        else:
            _user.update_movement(1)
        
        if randi_range(1, 10) > l:
            _user.update_initiative(-1)
        else:
            _user.update_initiative(1)
        
        if randi_range(1, 10) > l:
            _user.update_damage(-1)
        else:
            _user.update_damage(1)
        
        if randi_range(1, 10) > l:
            _user.update_armor(-1)
        else:
            _user.update_armor(1)
        return
    var d = "Put some bootleg parts on, resulting in added or removed stats"
    var action := _add_action(ent, "Bootleg Upgrades", d, [], effect, type, stats, "res://Effects/upgrade_effect.tscn")
    action.highlight_style = Highlights.HEAL
    action.target_animation = TargetAnimations.BUFF
    return

static func add_battlefield_transfer(ent: Entity, type: int):
    var stats = {
        "Affects": "Other Allied Units",
    }
    var effect = func (_user: Entity, _targets: Array, _action: Action):
        for _ent in _targets:
            _ent.update_damage(_user.damage_modifier)
            _ent.update_initiative(_user.initiative_modifier)
            _ent.update_movement(_user.movement_modifier)
            _ent.update_armor(_user.armor_modifier)
            _user.update_damage(-_user.damage_modifier)
            _user.update_initiative(-_user.initiative_modifier)
            _user.update_movement(-_user.movement_modifier)
            _user.update_armor(-_user.armor_modifier)
        return
    var d = "Transfer all movement, damage, armor, and initiative upgrades and downgrades to another allied unit"
    var action := _add_action(ent, "Battlefield Transfer", d, [], effect, type, stats, "res://Effects/upgrade_effect.tscn")
    action.highlight_style = Highlights.HEAL
    action.target_animation = TargetAnimations.BUFF
    return

static func add_heal_pulse(ent: Entity, type: int):
    var stats = {
        "Affects": TargetTypes.OTHER_ALLIES,
        "Heal Amount": [6, 8, 10, 12],
        "Set Range": 1,
        "Cost": 2,
    }
    var effect = func (_user: Entity, _targets: Array, _action: Action):
        for _ent in _targets:
            _ent.gainHP(_action.get_from_stats("Heal Amount"))
        return
    var d = "Heal all allies in a cone area"
    var action := _add_action(ent, "Heal Pulse", d, cone_reverse, effect, type, stats, "res://Effects/upgrade_effect.tscn")
    action.highlight_style = Highlights.HEAL
    action.target_animation = TargetAnimations.BUFF
    return

static func add_halo(ent: Entity, type: int):
    var stats = {
        "Affects": TargetTypes.SELF,
        "Heal Amount": 15,
    }
    var effect = func (_user: Entity, _targets: Array, _action: Action):
        for _ent in _targets:
            _ent.gainHP(_action.get_from_stats("Heal Amount"))
        return
    var d = "Restore a large amount of health to all allies in an area around Pulsar"
    var action := _add_action(ent, "Halo", d, diamond, effect, type, stats, "res://Effects/upgrade_effect.tscn")
    action.highlight_style = Highlights.HEAL
    action.target_animation = TargetAnimations.BUFF
    return

static func add_drill_strike(ent: Entity, type: int):
    var stats = {
        "Affects": TargetTypes.ENEMIES,
        "Number of Attacks": [2,3,4,5],
        "Damage Amp": .5,
        "Cost": 2,
        "Threat Gain": 2
    }
    var effect = func (_user: Entity, _targets: Array, _action: Action):
        var damage = ceili(_user.get_damage() * _action.get_from_stats("Damage Amp"))
        for _ent in _targets:
            for i in range(_action.get_from_stats("Number of Attacks")):
                _user.damage_done += _ent.damage_preview(damage)
                _ent.loseHP(damage)
                if randf() < _user.armor_break_chance:
                    _ent.update_armor(-1)
        return
    var d = "Attack all enemies in front multiple times with reduced damage"
    var action := _add_action(ent, "Drill Strike", d, cone, effect, type, stats, "res://Effects/explosion_yellow.tscn")
    action.target_animation = TargetAnimations.HIT
    return

static func add_drill_barrage(ent: Entity, type: int):
    var stats = {
        "Affects": TargetTypes.ENEMIES,
        "Number of Attacks": 5,
        "Threat Gain": 3
    }
    var effect = func (_user: Entity, _targets: Array, _action: Action):
        var damage = _user.get_damage()
        for _ent in _targets:
            for i in range(_action.get_from_stats("Number of Attacks")):
                _user.damage_done += _ent.damage_preview(damage)
                _ent.loseHP(damage)
                if randf() < _user.armor_break_chance:
                    _ent.update_armor(-1)
        return
    var d = "Unleash a barrage of drill attacks in front with no reduced damage"
    var action := _add_action(ent, "Drill Barrage", d, cone, effect, type, stats, "res://Effects/explosion_yellow.tscn")
    action.target_animation = TargetAnimations.HIT
    return
    
static func add_alpha_slash(ent: Entity, type: int):
    var stats = {
        "Affects": TargetTypes.ENEMIES,
        "Extra Damage": [2,4,6,8],
        "Slash Distance": 3,
        "Cost": 2,
        "Threat Gain": 1
    }
    var effect = func (_user: Entity, _targets: Array, _action: Action):
        var damage = _user.get_damage()
        for _ent in _targets:
            if randf() < _user.crit_chance:
                damage += _user.get_damage()
                _ent.custom_text("Crit!", Color.YELLOW)
            _user.damage_done += _ent.damage_preview(damage)
            _ent.loseHP(damage)
        return
    var d = "Dash forward, slashing all enemies in your path"
    var action := _add_action(ent, "Alpha Slash", d, straight, effect, type, stats, "res://Effects/explosion_yellow.tscn")
    action.target_animation = TargetAnimations.HIT
    return

static func add_zeta_slash(ent: Entity, type: int):
    var stats = {
        "Affects": TargetTypes.ALL_ENEMIES,
        "Crit Chance": "100%",
    }
    var effect = func (_user: Entity, _targets: Array, _action: Action):
        var damage = (_user.get_damage()  + _user.get_damage())
        for _ent in _targets:
            _ent.custom_text("Crit!", Color.YELLOW)
            _user.damage_done += _ent.damage_preview(damage)
            _ent.loseHP(damage)
        return
    var d = "Dash and strike every single enemy at their weakpoints with critical damage"
    var action := _add_action(ent, "Zeta slash", d, cone, effect, type, stats, "res://Effects/explosion_yellow.tscn")
    action.target_animation = TargetAnimations.HIT
    return

static func _add_action(ent, display_name, description, shape, effect, action_type, stats, animation_path = "") -> Action:
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
    return action
