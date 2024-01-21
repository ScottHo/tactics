class_name EntityFactory

enum Bot {BRUTUS, OILEE, ELECTO, NANONANO, SMITHY, LONGSHOT, BATTERIE, PUNCHE, PEPPERSHOT, BUSTER}

static func create_bot(bot: Bot) -> Entity:
    var ret = Entity.new()
    if bot == Bot.BRUTUS:
        ret = create_brutus()
    if bot == Bot.OILEE:
        ret = create_oilee()
    if bot == Bot.ELECTO:
        ret = create_electo()
    if bot == Bot.NANONANO:
        ret = create_nanonano()
    if bot == Bot.SMITHY:
        ret = create_smithy()
    if bot == Bot.LONGSHOT:
        ret = create_longshot()
    if bot == Bot.BATTERIE:
        ret = create_batterie()
    if bot == Bot.PUNCHE:
        ret = create_punch_e()
    if bot == Bot.PEPPERSHOT:
        ret = create_peppershot()
    if bot == Bot.BUSTER:
        ret = create_buster()
    ret.collection_id = bot
    return ret
    
static func new_recruits() -> Array:
    var all_bots = EntityFactory.Bot.values()
    all_bots.shuffle()
    var ret = []
    for b in all_bots:
        if b not in Globals.bots_collected:
            ret.append(b)
            if len(ret) == 3:
                return ret
    return ret

static func create_god_mode():
    var ent = _create_entity("Godshot", 999, 12, 10, 10, "res://Bots/longshot.tscn", "res://Assets/LongShot.png", true)
    ent.damage += 200
    var p = Passive.new()
    p.display_name = "God Mode"
    p.description = "???"
    ent.passive = p
    ActionFactory.add_base_attack(ent)
    ActionFactory.add_snipe(ent, ActionType.ACTION1)
    ActionFactory.add_god_shot(ent, ActionType.ACTION2)
    return ent
        
static func create_brutus():
    var ent = _create_entity("Brutis", 21, 5, 1, 10, "res://Bots/brutus.tscn", "res://Assets/Brutus.png", true)
    ent.armor += 1
    var p = Passive.new()
    p.display_name = "Thorned Armor"
    p.description = "When Brutis get's Normal Attacked, attackers take damage based on Brutis's damage"
    p.static_effect = func(e: Entity):
        e.thorns = true
    p.is_static = true
    ent.passive = p
    ActionFactory.add_base_attack(ent)
    ActionFactory.add_sturdy_stance(ent, ActionType.ACTION1)
    ActionFactory.add_flying_barb_stance(ent, ActionType.ACTION2)
    return ent
    
static func create_oilee():
    var ent = _create_entity("Oilee", 20, 1, 1, 10, "res://Bots/oilee.tscn", "res://Assets/Oilee.png", true)
    var p = Passive.new()
    p.display_name = "Grease Wheels"
    p.description = "Every turn, increase movement by 1 (max 20)"
    p.repeated_effect = func(e: Entity):
        if e.movement_modifier >= 20:
            e.custom_text("Maxed Grease", Color.WHITE)
        else:
            e.update_movement(1)
    p.is_repeated = true
    ent.passive = p
    ActionFactory.add_base_attack(ent)
    ActionFactory.add_oil_bomb(ent, ActionType.ACTION1)
    ActionFactory.add_winding_strike(ent, ActionType.ACTION2)
    return ent

static func create_electo():
    var ent = _create_entity("Electo", 18, 4, 4, 10, "res://Bots/electo.tscn", "res://Assets/Electo.png", true)
    var p = Passive.new()
    p.display_name = "Chain Lightning"
    p.description = "Electo's Normal Attacks bounce once to the nearest enemy within 3 tiles"
    p.static_effect = func(e: Entity):
        e.chain_attack = true
    p.is_static = true
    ent.passive = p
    ActionFactory.add_base_attack(ent)
    ActionFactory.add_storm(ent, ActionType.ACTION1)
    ActionFactory.add_thunderous_wrath(ent, ActionType.ACTION2)
    return ent

static func create_nanonano():
    var ent = _create_entity("Nano-nano", 21, 4, 3, 10, "res://Bots/nanonano.tscn", "res://Assets/NanoNano.png", true)
    var p = Passive.new()
    p.display_name = "Nanobot Attendants"
    p.description = "Allied units in a square near Nano-nano gain 2 health at start of turn"
    p.aura_short_desc = "+2 HP Regen"
    p.aura_effect = func(e: Entity):
        e.aura_regen = 2
    p.is_aura = true
    ent.passive = p
    ActionFactory.add_base_attack(ent)
    ActionFactory.add_nano_field(ent, ActionType.ACTION1)
    ActionFactory.add_swarm_of_pain(ent, ActionType.ACTION2)
    return ent

static func create_smithy():
    var ent = _create_entity("Smithy", 20, 5, 1, 10, "res://Bots/smithy.tscn", "res://Assets/Smithy.png", true)
    ent.damage -= 1
    var p = Passive.new()
    p.display_name = "Quick Assist"
    p.description = "Allied units in a square near Smithy have +1 damage"
    p.aura_short_desc = "+1 Damage"
    p.aura_effect = func(e: Entity):
        e.aura_damage_modifier = 1
    p.is_aura = true
    ent.passive = p
    ActionFactory.add_base_attack(ent)
    ActionFactory.add_weapons_upgade(ent, ActionType.ACTION1)
    ActionFactory.add_auto_turret_3000(ent, ActionType.ACTION2)
    return ent

static func create_longshot():
    var ent = _create_entity("Longshot", 16, 4, 4, 10, "res://Bots/longshot.tscn", "res://Assets/LongShot.png", true)
    var p = Passive.new()
    p.display_name = "Marksman Advice"
    p.description = "Allied units in a square near Longshot have +1 range"
    p.aura_short_desc = "+1 Range"    
    p.aura_effect = func(e: Entity):
        e.aura_range_modifier = 1
    p.is_aura = true
    ent.passive = p
    ActionFactory.add_base_attack(ent)
    ActionFactory.add_snipe(ent, ActionType.ACTION1)
    ActionFactory.add_god_shot(ent, ActionType.ACTION2)
    return ent

static func create_batterie():
    var ent = _create_entity("Batterie", 17, 4, 3, 10, "res://Bots/batterie.tscn", "res://Assets/batterie.png", true)
    var p = Passive.new()
    p.display_name = "Circuit Efficiency"
    p.description = "Gain one extra energy per turn"
    p.repeated_effect = func(e: Entity):
        e.update_energy(1)
    p.is_repeated = true
    ent.passive = p
    ActionFactory.add_base_attack(ent)
    ActionFactory.add_power_up(ent, ActionType.ACTION1)
    ActionFactory.add_ultimate_shiphon(ent, ActionType.ACTION2)
    return ent

static func create_punch_e():
    var ent = _create_entity("Punch-E", 18, 5, 1, 10, "res://Bots/punch-e.tscn", "res://Assets/punch-e.png", true)
    var p = Passive.new()
    p.display_name = "Reckless Fighter"
    p.description = "Punch-E starts with -2 armor and +2 damage"
    p.static_effect = func(e: Entity):
        e.damage_modifier += 2
        e.armor_modifier -= 2
    p.is_static = true
    ent.passive = p
    ActionFactory.add_base_attack(ent)
    ActionFactory.add_robo_punch(ent, ActionType.ACTION1)
    ActionFactory.add_KO_punch(ent, ActionType.ACTION2)
    return ent

static func create_peppershot():
    var ent = _create_entity("Peppershot", 15, 4, 4, 10, "res://Bots/peppershot.tscn", "res://Assets/peppershot.png", true)
    var p = Passive.new()
    p.display_name = "Dizzy Moves"
    p.description = "Peppershot has a 20% chance for any attack to miss"
    p.static_effect = func(e: Entity):
        e.dodge_chance = .2
    p.is_static = true
    ent.passive = p
    ActionFactory.add_base_attack(ent)
    ActionFactory.add_spray_and_pray(ent, ActionType.ACTION1)
    ActionFactory.add_bullet_rain(ent, ActionType.ACTION2)    
    return ent

static func create_buster():
    var ent = _create_entity("Buster", 20, 5, 1, 10, "res://Bots/buster.tscn", "res://Assets/bot_template.png", true)
    var p = Passive.new()
    p.display_name = "Self Diagnosis"
    p.description = "Buster has a 20% chance to remove all downgrades per turn"
    p.repeated_effect = func(e: Entity):
        e.wipe_downgrades_chance = .2
    p.is_repeated = true
    ent.passive = p
    ActionFactory.add_base_attack(ent)
    ActionFactory.add_bootleg_upgrades(ent, ActionType.ACTION1)
    ActionFactory.add_battlefield_transfer(ent, ActionType.ACTION2)
    return ent

static func create_auto_turret_3000():
    var ent = _create_entity("Auto Turret 3000", 5, 0, 5, 15, "res://Bots/buster.tscn", "res://Assets/bot_template.png", true)
    ent.damage += 6
    ent.is_add = true
    ActionFactory.add_base_attack(ent)
    return ent

static func create_boss_1_1():
    var ent = _create_entity("Bronze Grunt", 50, 5, 1, 10, "res://Bots/enemy_1.tscn", "res://Assets/Boss1.png", false)
    ActionFactory.add_base_attack(ent)
    return ent

static func create_boss_1_2():
    var ent = _create_entity("Bronze Grunt", 75, 5, 1, 10, "res://Bots/enemy_2.tscn", "res://Assets/boss2.png", false)
    ActionFactory.add_base_attack(ent)
    return ent

static func create_boss_1_3():
    var ent = _create_entity("Bronze Grunt", 100, 5, 1, 10, "res://Bots/enemy_3.tscn", "res://Assets/boss3.png", false)
    ActionFactory.add_base_attack(ent)
    return ent

static func create_boss_1_f():
    var ent = _create_entity("Bronze Bull", 150, 5, 1, 10, "res://Bots/bronze_bull.tscn", "res://Assets/Bots/bronze_boss.png", false)
    ent.damage += 2
    ActionFactory.add_base_attack(ent)
    return ent

static func create_boss_spawn_1():
    var ent = _create_entity("Mini Bronze Grunt", 6, 3, 1, 10, "res://Bots/boss_spawn_1.tscn", "res://Assets/boss_spawn_1.png", false)
    ent.is_add = true
    ent.damage -= 1
    ActionFactory.add_base_attack(ent)
    return ent

static func create_boss_spawn_1_f():
    var ent = _create_entity("Animated Bronze Soul", 10, 3, 1, 10, "res://Bots/bronze_spawn.tscn", "res://Assets/Bots/bronze_spawn.png", false)
    ent.is_add = true
    ent.spawn_on_death = InteractableFactory.bronze_soul()
    ActionFactory.add_base_attack(ent)
    return ent

static func create_boss_2_1():
    var ent = _create_entity("Iron Grunt", 150, 5, 1, 10, "res://Bots/enemy_1.tscn", "res://Assets/Boss1.png", false)
    ent.damage += 2
    ActionFactory.add_base_attack(ent)
    return ent

static func create_boss_2_2():
    var ent = _create_entity("Iron Grunt", 175, 5, 1, 10, "res://Bots/enemy_2.tscn", "res://Assets/boss2.png", false)
    ent.damage += 2
    ActionFactory.add_base_attack(ent)
    return ent

static func create_boss_2_3():
    var ent = _create_entity("Iron Grunt", 200, 5, 1, 10, "res://Bots/enemy_3.tscn", "res://Assets/boss3.png", false)
    ent.damage += 2
    ActionFactory.add_base_attack(ent)
    return ent

static func create_boss_2_f():
    var ent = _create_entity("Iron Boss", 200, 5, 1, 10, "res://Bots/bronze_bull.tscn", "res://Assets/Bots/bronze_boss.png", false)
    ent.damage += 4
    ent.armor += 2
    ActionFactory.add_base_attack(ent)
    return ent

static func create_boss_spawn_2():
    var ent = _create_entity("Mini Iron Grunt", 8, 3, 1, 10, "res://Bots/boss_spawn_1.tscn", "res://Assets/boss_spawn_1.png", false)
    ent.is_add = true
    ActionFactory.add_base_attack(ent)
    return ent

static func create_boss_3_1():
    var ent = _create_entity("Steel Grunt", 200, 5, 1, 10, "res://Bots/enemy_1.tscn", "res://Assets/Boss1.png", false)
    ent.damage += 4
    ActionFactory.add_base_attack(ent)
    return ent

static func create_boss_3_2():
    var ent = _create_entity("Steel Grunt", 225, 5, 1, 10, "res://Bots/enemy_2.tscn", "res://Assets/boss2.png", false)
    ent.damage += 4
    ActionFactory.add_base_attack(ent)
    return ent

static func create_boss_3_3():
    var ent = _create_entity("Steel Grunt", 250, 5, 1, 10, "res://Bots/enemy_3.tscn", "res://Assets/boss3.png", false)
    ent.damage += 4
    ActionFactory.add_base_attack(ent)
    return ent

static func create_boss_3_f():
    var ent = _create_entity("Steel Boss", 300, 5, 1, 10, "res://Bots/bronze_bull.tscn", "res://Assets/Bots/bronze_boss.png", false)
    ent.damage += 4
    ActionFactory.add_base_attack(ent)
    return ent

static func create_boss_spawn_3():
    var ent = _create_entity("Mini Steel Grunt", 12, 3, 1, 8, "res://Bots/boss_spawn_1.tscn", "res://Assets/boss_spawn_1.png", false)
    ent.damage += 6
    ent.is_add = true
    ActionFactory.add_base_attack(ent)
    return ent

static func create_boss_4_1():
    var ent = _create_entity("Platinum Grunt", 275, 5, 1, 10, "res://Bots/enemy_1.tscn", "res://Assets/Boss1.png", false)
    ent.damage += 5
    ActionFactory.add_base_attack(ent)
    return ent

static func create_boss_4_2():
    var ent = _create_entity("Platinum Grunt", 300, 5, 1, 10, "res://Bots/enemy_2.tscn", "res://Assets/boss2.png", false)
    ent.damage += 5
    ActionFactory.add_base_attack(ent)
    return ent

static func create_boss_4_3():
    var ent = _create_entity("Platinum Grunt", 325, 5, 1, 10, "res://Bots/enemy_3.tscn", "res://Assets/boss3.png", false)
    ent.damage += 5
    ActionFactory.add_base_attack(ent)
    return ent

static func create_boss_4_f():
    var ent = _create_entity("Platinum Foundry Boss", 500, 5, 1, 10, "res://Bots/bronze_bull.tscn", "res://Assets/Bots/bronze_boss.png", false)
    ent.damage += 5
    ActionFactory.add_base_attack(ent)
    return ent

static func create_boss_spawn_4():
    var ent = _create_entity("Mini Platinum Grunt", 14, 3, 1, 8, "res://Bots/boss_spawn_1.tscn", "res://Assets/boss_spawn_1.png", false)
    ent.damage += 7
    ent.is_add = true
    ActionFactory.add_base_attack(ent)
    return ent

static func create_boss_final():
    var ent = _create_entity("Chief Executive Foundry", 1000, 5, 1, 10, "res://Bots/bronze_bull.tscn", "res://Assets/Bots/bronze_boss.png", false)
    ent.damage += 6
    ActionFactory.add_base_attack(ent)
    return ent

static func _create_entity(display_name, health, movement, _range, initiative, sprite_path, icon_path, ally):
    var ent = Entity.new()
    ent.sprite_path = sprite_path
    ent.icon_path = icon_path
    ent.alive = true
    ent.damage = 4
    ent.display_name = display_name
    ent.movement = movement
    ent.range = _range
    ent.initiative = initiative
    ent.set_max_health(health)
    ent.set_hp(health)
    ent.setThreat(0)
    ent.energy = 0
    ent.is_ally = ally
    return ent
