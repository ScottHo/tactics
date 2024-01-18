class_name EntityFactory

enum Bot {BRUTUS, OILEE, ELECTO, NANONANO, SMITHY, LONGSHOT, BATTERIE, PUNCHE, PEPPERSHOT, BUSTER}

static func create_bot(bot: Bot) -> Entity:
    if bot == Bot.BRUTUS:
        return create_brutus()
    if bot == Bot.OILEE:
        return create_oilee()
    if bot == Bot.ELECTO:
        return create_electo()
    if bot == Bot.NANONANO:
        return create_nanonano()
    if bot == Bot.SMITHY:
        return create_smithy()
    if bot == Bot.LONGSHOT:
        return create_longshot()
    if bot == Bot.BATTERIE:
        return create_batterie()
    if bot == Bot.PUNCHE:
        return create_punch_e()
    if bot == Bot.PEPPERSHOT:
        return create_peppershot()
    if bot == Bot.BUSTER:
        return create_buster()
    return Entity.new()
    
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
    ActionFactory.add_base_attack(ent)
    ActionFactory.add_snipe(ent, ActionType.ACTION1)
    ActionFactory.add_titanium_bullet(ent, ActionType.ACTION2)
    return ent
        
static func create_brutus():
    var ent = _create_entity("Brutis", 21, 5, 1, 10, "res://Bots/brutus.tscn", "res://Assets/Brutus.png", true)
    ActionFactory.add_base_attack(ent)
    ActionFactory.add_exert(ent, ActionType.ACTION1)
    ActionFactory.add_bolster(ent, ActionType.ACTION2)
    return ent
    
static func create_oilee():
    var ent = _create_entity("Oilee", 20, 6, 1, 10, "res://Bots/oilee.tscn", "res://Assets/Oilee.png", true)
    ActionFactory.add_base_attack(ent)
    ActionFactory.add_oil_bomb(ent, ActionType.ACTION1)
    ActionFactory.add_lubricate(ent, ActionType.ACTION2)
    return ent

static func create_electo():
    var ent = _create_entity("Electo", 18, 4, 4, 10, "res://Bots/electo.tscn", "res://Assets/Electo.png", true)
    ActionFactory.add_base_attack(ent)
    ActionFactory.add_storm(ent, ActionType.ACTION1)
    ActionFactory.add_static_shield(ent, ActionType.ACTION2)
    return ent

static func create_nanonano():
    var ent = _create_entity("Nano-nano", 18, 4, 3, 10, "res://Bots/nanonano.tscn", "res://Assets/NanoNano.png", true)
    ActionFactory.add_base_attack(ent)
    ActionFactory.add_focused_repair(ent, ActionType.ACTION1)
    ActionFactory.add_nano_field(ent, ActionType.ACTION2)
    return ent

static func create_smithy():
    var ent = _create_entity("Smithy", 20, 5, 1, 10, "res://Bots/smithy.tscn", "res://Assets/Smithy.png", true)
    ActionFactory.add_base_attack(ent)
    ActionFactory.add_weapons_upgade(ent, ActionType.ACTION1)
    ActionFactory.add_engine_upgrade(ent, ActionType.ACTION2)
    return ent

static func create_longshot():
    var ent = _create_entity("Longshot", 16, 4, 5, 10, "res://Bots/longshot.tscn", "res://Assets/LongShot.png", true)
    ActionFactory.add_base_attack(ent)
    ActionFactory.add_snipe(ent, ActionType.ACTION1)
    ActionFactory.add_titanium_bullet(ent, ActionType.ACTION2)
    return ent

static func create_batterie():
    var ent = _create_entity("Batterie", 17, 4, 3, 10, "res://Bots/batterie.tscn", "res://Assets/batterie.png", true)
    ActionFactory.add_base_attack(ent)
    ActionFactory.add_power_up(ent, ActionType.ACTION1)
    ActionFactory.add_shock_therapy(ent, ActionType.ACTION2)
    return ent

static func create_punch_e():
    var ent = _create_entity("Punch-E", 18, 5, 1, 10, "res://Bots/punch-e.tscn", "res://Assets/punch-e.png", true)
    ActionFactory.add_base_attack(ent)
    ActionFactory.add_precise_strike(ent, ActionType.ACTION1)
    ActionFactory.add_robo_punch(ent, ActionType.ACTION2)
    return ent

static func create_peppershot():
    var ent = _create_entity("Peppershot", 16, 4, 4, 10, "res://Bots/peppershot.tscn", "res://Assets/peppershot.png", true)
    ActionFactory.add_base_attack(ent)
    ActionFactory.add_scatter_shot(ent, ActionType.ACTION1)
    ActionFactory.add_spray_and_pray(ent, ActionType.ACTION2)
    return ent

static func create_buster():
    var ent = _create_entity("Buster", 20, 5, 1, 10, "res://Bots/buster.tscn", "res://Assets/bot_template.png", true)
    ActionFactory.add_base_attack(ent)
    ActionFactory.add_double_strike(ent, ActionType.ACTION1)
    ActionFactory.add_bootleg_upgrades(ent, ActionType.ACTION2)
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
    var ent = _create_entity("Mini Bronze Grunt", 7, 3, 1, 10, "res://Bots/boss_spawn_1.tscn", "res://Assets/boss_spawn_1.png", false)
    ent.damage += 2
    ent.is_add = true
    ActionFactory.add_base_attack(ent)
    return ent

static func create_boss_spawn_1_f():
    var ent = _create_entity("Animated Bronze Soul", 10, 3, 1, 10, "res://Bots/bronze_spawn.tscn", "res://Assets/Bots/bronze_spawn.png", false)
    ent.is_add = true
    ent.spawn_on_death = InteractableFactory.bronze_soul()
    ActionFactory.add_base_attack(ent)
    return ent

static func create_boss_2_1():
    var ent = _create_entity("Iron Grunt", 100, 5, 1, 10, "res://Bots/enemy_1.tscn", "res://Assets/Boss1.png", false)
    ent.damage += 2
    ActionFactory.add_base_attack(ent)
    return ent

static func create_boss_2_2():
    var ent = _create_entity("Iron Grunt", 120, 5, 1, 10, "res://Bots/enemy_2.tscn", "res://Assets/boss2.png", false)
    ent.damage += 2
    ActionFactory.add_base_attack(ent)
    return ent

static func create_boss_2_3():
    var ent = _create_entity("Iron Grunt", 140, 5, 1, 10, "res://Bots/enemy_3.tscn", "res://Assets/boss3.png", false)
    ent.damage += 2
    ActionFactory.add_base_attack(ent)
    return ent

static func create_boss_2_f():
    var ent = _create_entity("Iron Foundry Boss", 200, 5, 1, 10, "res://Bots/bronze_bull.tscn", "res://Assets/Bots/bronze_boss.png", false)
    ent.damage += 3
    ActionFactory.add_base_attack(ent)
    return ent

static func create_boss_spawn_2():
    var ent = _create_entity("Mini Iron Grunt", 9, 3, 1, 10, "res://Bots/boss_spawn_1.tscn", "res://Assets/boss_spawn_1.png", false)
    ent.damage += 5
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
