class_name MissionFactory

static func foundry_1_final_boss() -> Mission:
    var m = Mission.new()
    m.boss = EntityFactory.create_boss_1()
    m.buffs = InteractableFactory.random_set()
    m.specials_per_turn = 2

    var s1 = Special.new()
    s1.display_name = "Big Bot Energy"
    s1.description = "Gains 1 initiative, 1 movement, 1 armor, and 1 damage"
    s1.target = Special.Target.SELF
    s1.shape = Special.Shape.SINGLE
    s1.mechanic = Special.Mechanic.BUFF
    s1.damage = 0
    s1.effect = func(ent: Entity):
        ent.update_initiative(1)
        ent.update_movement(1)
        ent.update_damage(1)
        ent.update_armor(1)
    s1.animation_path = "res://Effects/upgrade_effect.tscn"
    

    m.specials = [s1]
    return m

static func foundry_2_final_boss() -> Mission:
    var m = Mission.new()
    m.boss = EntityFactory.create_boss_2()
    m.buffs = InteractableFactory.random_set()
    m.specials_per_turn = 3

    var s1 = Special.new()    
    s1.display_name = "Deploy Minions"
    s1.description = "Deploy 3 minions with high base damage"
    s1.target = Special.Target.SPAWN_CLOSE
    s1.shape = Special.Shape.OCTAGON
    s1.mechanic = Special.Mechanic.SPAWN
    s1.spawns = [EntityFactory.create_boss_spawn_1(), EntityFactory.create_boss_spawn_1(),
            EntityFactory.create_boss_spawn_1()]


    var s2 = Special.new()
    s2.display_name = "Hater Missle"
    s2.description = "Deal 12 damage to the highest threat target, then removing all it's threat"
    s2.target = Special.Target.THREAT
    s2.shape = Special.Shape.SINGLE
    s2.mechanic = Special.Mechanic.SPREAD
    s2.damage = 12
    s2.effect = func(ent: Entity):
        ent.setThreat(0)
        return
    s2.animation_path = "res://Effects/explosion_yellow.tscn"
    
    m.specials = [s1, s2]
    return m

static func foundry_3_final_boss() -> Mission:
    var m = Mission.new()
    m.boss = EntityFactory.create_boss_3()
    m.buffs = InteractableFactory.random_set()
    m.specials_per_turn = 3

    var s1 = Special.new()
    s1.display_name = "Massive Nuke"
    s1.description = "Deals 21 damage spread over every allied unit in a diamond tile area, centered on a random allied unit"
    s1.target = Special.Target.RANDOM
    s1.shape = Special.Shape.DIAMOND_3x3
    s1.mechanic = Special.Mechanic.SOAK
    s1.damage = 21
    s1.effect = func(ent: Entity):
        return
    s1.animation_path = "res://Effects/explosion_yellow.tscn"

    var s2 = Special.new()
    s2.display_name = "Widespread destruction"
    s2.description = "Deals 7 damage to every allied unit in a square area, centered on every allied unit"
    s2.target = Special.Target.ALL
    s2.shape = Special.Shape.SQUARE_3x3
    s2.mechanic = Special.Mechanic.SPREAD
    s2.damage = 7
    s2.effect = func(ent: Entity):
        return
    s2.animation_path = "res://Effects/explosion_yellow.tscn"

    var s3 = Special.new()
    s3.display_name = "Overclock"
    s3.description = "Gains 2 initiative"
    s3.target = Special.Target.SELF
    s3.shape = Special.Shape.SINGLE
    s3.mechanic = Special.Mechanic.BUFF
    s3.damage = 0
    s3.effect = func(ent: Entity):
        ent.update_initiative(2)
    s3.animation_path = "res://Effects/upgrade_effect.tscn"

    
    m.specials = [s1, s2, s3]
    return m

static func foundry_1_floors(floor: int) -> Array:
    var specs = foundry_1_specials(floor)
    specs.shuffle()
    var ret = []
    for i in range(3):
        var m = Mission.new()
        m.boss = EntityFactory.create_boss_1()
        m.specials = [specs[i]]
        m.buffs = InteractableFactory.random_set()
        m.specials_per_turn = 1
        ret.append(m)
    return ret

static func foundry_2_floors(floor: int) -> Array:
    var specs = foundry_2_specials(floor)
    specs.shuffle()
    var ret = []
    for i in range(3):
        var m = Mission.new()
        m.boss = EntityFactory.create_boss_2()
        m.specials = [specs[ i * 2 ], specs[i * 2 + 1]]
        m.buffs = InteractableFactory.random_set()
        m.specials_per_turn = 2
        ret.append(m)
    return ret

static func foundry_3_floors(floor: int) -> Array:
    var specs = foundry_3_specials(floor)
    specs.shuffle()
    var ret = []
    for i in range(3):
        var m = Mission.new()
        m.boss = EntityFactory.create_boss_3()
        m.specials = [specs[ i * 3 ], specs[i * 3 + 1], specs[i * 3 + 2]]
        m.buffs = InteractableFactory.random_set()
        m.specials_per_turn = 3
        ret.append(m)
    return ret

static func foundry_1_specials(floor: int) -> Array:
    var ret = []
    var s = Special.new()
    s.display_name = "Big Bot Energy"
    s.description = "Gains 1 initiative, 1 movement, 1 armor, and 1 damage"
    s.target = Special.Target.SELF
    s.shape = Special.Shape.SINGLE
    s.mechanic = Special.Mechanic.BUFF
    s.damage = 0
    s.effect = func(ent: Entity):
        ent.update_initiative(1)
        ent.update_movement(1)
        ent.update_damage(1)
        ent.update_armor(1)
    s.animation_path = "res://Effects/upgrade_effect.tscn"
    ret.append(s)
        
    s = Special.new()
    s.display_name = "Massive Nuke"
    s.description = "Deals 21 damage spread over every allied unit in a diamond tile area, centered on a random allied unit"
    s.target = Special.Target.RANDOM
    s.shape = Special.Shape.DIAMOND_3x3
    s.mechanic = Special.Mechanic.SOAK
    s.damage = 21
    s.effect = func(ent: Entity):
        return
    s.animation_path = "res://Effects/explosion_yellow.tscn"
    ret.append(s)

    s = Special.new()
    s.display_name = "Widespread destruction"
    s.description = "Deals 7 damage to every allied unit in a square area, centered on every allied unit"
    s.target = Special.Target.ALL
    s.shape = Special.Shape.SQUARE_3x3
    s.mechanic = Special.Mechanic.SPREAD
    s.damage = 7
    s.effect = func(ent: Entity):
        return
    s.animation_path = "res://Effects/explosion_yellow.tscn"
    ret.append(s)

    s = Special.new()
    s.display_name = "Overclock"
    s.description = "Gains 2 initiative"
    s.target = Special.Target.SELF
    s.shape = Special.Shape.SINGLE
    s.mechanic = Special.Mechanic.BUFF
    s.damage = 0
    s.effect = func(ent: Entity):
        ent.update_initiative(2)
        return
    s.animation_path = "res://Effects/upgrade_effect.tscn"
    ret.append(s)

    s = Special.new()    
    s.display_name = "Deploy Minions"
    s.description = "Deploy 3 minions with high base damage"
    s.target = Special.Target.SPAWN_CLOSE
    s.shape = Special.Shape.OCTAGON
    s.mechanic = Special.Mechanic.SPAWN
    s.spawns = [EntityFactory.create_boss_spawn_1(), EntityFactory.create_boss_spawn_1(),
            EntityFactory.create_boss_spawn_1()]
    ret.append(s)

    s = Special.new()
    s.display_name = "Hater Missle"
    s.description = "Deal 12 damage to the highest threat target, then removing all it's threat"
    s.target = Special.Target.THREAT
    s.shape = Special.Shape.SINGLE
    s.mechanic = Special.Mechanic.SPREAD
    s.damage = 12
    s.effect = func(ent: Entity):
        ent.setThreat(0)
        return
    ret.append(s)
    s.animation_path = "res://Effects/explosion_yellow.tscn"
    return ret

static func foundry_2_specials(floor: int) -> Array:
    return foundry_1_specials(floor)

static func foundry_3_specials(floor: int) -> Array:
    return foundry_1_specials(floor)
