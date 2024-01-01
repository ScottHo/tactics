class_name EntityFactory


static func create_brutus():
    var ent = _create_entity("Brutis", 10, 4, 1, 10, "res://brutus.tscn", "res://Assets/Brutus.png", true)
    ActionFactory.add_base_attack(ent)
    ActionFactory.add_exert(ent, ActionType.ACTION1)
    ActionFactory.add_take_cover(ent, ActionType.ACTION2)
    return ent
    
static func create_oilee():
    var ent = _create_entity("Oilee", 10, 5, 1, 10, "res://oilee.tscn", "res://Assets/Oilee.png", true)
    ActionFactory.add_base_attack(ent)
    ActionFactory.add_oil_bomb(ent, ActionType.ACTION1)
    ActionFactory.add_lubricate(ent, ActionType.ACTION2)
    return ent

static func create_electro():
    var ent = _create_entity("Electo", 10, 3, 4, 10, "res://electo.tscn", "res://Assets/Electo.png", true)
    ActionFactory.add_base_attack(ent)
    ActionFactory.add_storm(ent, ActionType.ACTION1)
    ActionFactory.add_static_shield(ent, ActionType.ACTION2)
    return ent

static func create_nanonano():
    var ent = _create_entity("Nano-nano", 10, 3, 4, 10, "res://nanonano.tscn", "res://Assets/NanoNano.png", true)
    ActionFactory.add_base_attack(ent)
    ActionFactory.add_focused_repair(ent, ActionType.ACTION1)
    ActionFactory.add_nano_field(ent, ActionType.ACTION2)
    return ent

static func create_smithy():
    var ent = _create_entity("Smithy", 10, 4, 1, 10, "res://smithy.tscn", "res://Assets/Smithy.png", true)
    ActionFactory.add_base_attack(ent)
    ActionFactory.add_weapons_upgade(ent, ActionType.ACTION1)
    ActionFactory.add_engine_upgrade(ent, ActionType.ACTION2)
    return ent

static func create_longshot():
    var ent = _create_entity("Longshot", 10, 4, 5, 10, "res://longshot.tscn", "res://Assets/LongShot.png", true)
    ActionFactory.add_base_attack(ent)
    ActionFactory.add_snipe(ent, ActionType.ACTION1)
    ActionFactory.add_titanium_bullet(ent, ActionType.ACTION2)
    return ent

static func create_boss_1():
    var ent = _create_entity("Evil Red", 30, 5, 1, 10, "res://enemy_1.tscn", "res://Assets/Boss1.png", false)
    ent.description = "Intimidating Placeholder Text"
    ent.damage += 1
    ActionFactory.add_base_attack(ent)
    return ent

static func create_boss_2():
    var ent = _create_entity("Evil Pink", 50, 2, 1, 8, "res://enemy_2.tscn", "res://Assets/boss2.png", false)
    ent.description = "Intimidating Placeholder Text"
    ActionFactory.add_base_attack(ent)
    return ent

static func create_boss_3():
    var ent = _create_entity("Evil Orange", 75, 6, 1, 10, "res://enemy_3.tscn", "res://Assets/boss3.png", false)
    ent.description = "Intimidating Placeholder Text"
    ent.damage += 1
    ActionFactory.add_base_attack(ent)
    return ent

static func _create_entity(display_name, health, movement, _range, initiative, sprite_path, icon_path, ally):
    var ent = Entity.new()
    ent.sprite_path = sprite_path
    ent.icon_path = icon_path
    ent.alive = true
    ent.damage = 2
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
