class_name EntityFactory


static func create_brutus():
    var ent = _create_entity("Brutis", 21, 4, 1, 10, "res://brutus.tscn", "res://Assets/Brutus.png", true)
    ActionFactory.add_base_attack(ent)
    ActionFactory.add_exert(ent, ActionType.ACTION1)
    ActionFactory.add_bolster(ent, ActionType.ACTION2)
    return ent
    
static func create_oilee():
    var ent = _create_entity("Oilee", 20, 5, 1, 10, "res://oilee.tscn", "res://Assets/Oilee.png", true)
    ActionFactory.add_base_attack(ent)
    ActionFactory.add_oil_bomb(ent, ActionType.ACTION1)
    ActionFactory.add_lubricate(ent, ActionType.ACTION2)
    return ent

static func create_electro():
    var ent = _create_entity("Electo", 18, 3, 4, 10, "res://electo.tscn", "res://Assets/Electo.png", true)
    ActionFactory.add_base_attack(ent)
    ActionFactory.add_storm(ent, ActionType.ACTION1)
    ActionFactory.add_static_shield(ent, ActionType.ACTION2)
    return ent

static func create_nanonano():
    var ent = _create_entity("Nano-nano", 18, 3, 3, 10, "res://nanonano.tscn", "res://Assets/NanoNano.png", true)
    ActionFactory.add_base_attack(ent)
    ActionFactory.add_focused_repair(ent, ActionType.ACTION1)
    ActionFactory.add_nano_field(ent, ActionType.ACTION2)
    return ent

static func create_smithy():
    var ent = _create_entity("Smithy", 20, 4, 1, 10, "res://smithy.tscn", "res://Assets/Smithy.png", true)
    ActionFactory.add_base_attack(ent)
    ActionFactory.add_weapons_upgade(ent, ActionType.ACTION1)
    ActionFactory.add_engine_upgrade(ent, ActionType.ACTION2)
    return ent

static func create_longshot():
    var ent = _create_entity("Longshot", 16, 4, 5, 10, "res://longshot.tscn", "res://Assets/LongShot.png", true)
    ActionFactory.add_base_attack(ent)
    ActionFactory.add_snipe(ent, ActionType.ACTION1)
    ActionFactory.add_titanium_bullet(ent, ActionType.ACTION2)
    return ent

static func create_batterie():
    var ent = _create_entity("Batterie", 17, 3, 3, 10, "res://batterie.tscn", "res://Assets/batterie.png", true)
    ActionFactory.add_base_attack(ent)
    ActionFactory.add_power_up(ent, ActionType.ACTION1)
    ActionFactory.add_shock_therapy(ent, ActionType.ACTION2)
    return ent

static func create_punch_e():
    var ent = _create_entity("Punch-E", 18, 5, 1, 10, "res://punch-e.tscn", "res://Assets/punch-e.png", true)
    ActionFactory.add_base_attack(ent)
    ActionFactory.add_precise_strike(ent, ActionType.ACTION1)
    ActionFactory.add_robo_punch(ent, ActionType.ACTION2)
    return ent

static func create_peppershot():
    var ent = _create_entity("Peppershot", 16, 3, 4, 10, "res://peppershot.tscn", "res://Assets/peppershot.png", true)
    ActionFactory.add_base_attack(ent)
    ActionFactory.add_scatter_shot(ent, ActionType.ACTION1)
    ActionFactory.add_spray_and_pray(ent, ActionType.ACTION2)
    return ent


static func create_boss_1():
    var ent = _create_entity("Evil Red", 200, 3, 1, 10, "res://enemy_1.tscn", "res://Assets/Boss1.png", false)
    ent.description = "Intimidating Placeholder Text"
    ent.damage += 4
    ActionFactory.add_base_attack(ent)
    return ent

static func create_boss_2():
    var ent = _create_entity("Evil Pink", 200, 4, 1, 10, "res://enemy_2.tscn", "res://Assets/boss2.png", false)
    ent.damage += 4
    ent.description = "Intimidating Placeholder Text"
    ActionFactory.add_base_attack(ent)
    return ent

static func create_boss_3():
    var ent = _create_entity("Evil Orange", 200, 4, 1, 10, "res://enemy_3.tscn", "res://Assets/boss3.png", false)
    ent.description = "Intimidating Placeholder Text"
    ent.damage += 4
    ActionFactory.add_base_attack(ent)
    return ent

static func create_boss_spawn_1():
    var ent = _create_entity("Mini Evil Gray", 15, 3, 1, 10, "res://boss_spawn_1.tscn", "res://Assets/boss_spawn_1.png", false)
    ent.description = "Intimidating Placeholder Text"
    ent.damage += 4
    ent.is_add = true
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
