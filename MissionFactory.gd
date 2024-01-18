class_name MissionFactory

static func foundry_1_final_boss() -> Mission:
    # Spread, Soak, Revivable Minions
    var m = Mission.new()
    m.boss = EntityFactory.create_boss_1_f()
    m.buffs = [InteractableFactory.bronze_soul()]
    m.specials_per_turn = 2

    var s1 = Special.new()
    s1.display_name = "Deploy Minions"
    s1.description = "Deploy 2 minions that spawn Bronze Souls on death"
    s1.target = Special.Target.SPAWN_CLOSE
    s1.shape = Special.Shape.OCTAGON
    s1.mechanic = Special.Mechanic.SPAWN
    s1.spawns = [EntityFactory.create_boss_spawn_1_f(), EntityFactory.create_boss_spawn_1_f()]

    var s2 = Special.new()
    s2.display_name = "Heatseaking Missles"
    s2.description = "Deals 3 damage to every allied unit in a square area, centered on every allied unit"
    s2.target = Special.Target.ALL
    s2.shape = Special.Shape.SQUARE_3x3
    s2.mechanic = Special.Mechanic.SPREAD
    s2.damage = 3
    s2.effect = func(ent: Entity):
        return
    s2.animation_path = "res://Effects/explosion_yellow.tscn"

    var s3 = Special.new()
    s3.display_name = "Revive Souls"
    s3.description = "For every bronze soul on the ground, create a minion"
    s3.target = Special.Target.INTERACTABLES
    s3.shape = Special.Shape.SINGLE
    s3.mechanic = Special.Mechanic.SPAWN
    s3.target_interactable = "Bronze Soul"
    s3.spawns = [EntityFactory.create_boss_spawn_1_f()]

    var s4 = Special.new()
    s4.display_name = "Big Ol' Missle"
    s4.description = "Deals 9 damage spread over every allied unit in a diamond area, centered on a random allied unit"
    s4.target = Special.Target.RANDOM
    s4.shape = Special.Shape.DIAMOND_3x3
    s4.mechanic = Special.Mechanic.SOAK
    s4.damage = 9
    s4.effect = func(ent: Entity):
        return
    s4.animation_path = "res://Effects/explosion_yellow.tscn"

    m.specials = [s1,s2,s3,s4]
    return m

static func foundry_2_final_boss() -> Mission:
    # Spread,
    var m = Mission.new()
    m.boss = EntityFactory.create_boss_2_f()
    m.buffs = []
    m.specials_per_turn = 2

    # TODO
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
    m.boss = EntityFactory.create_boss_3_f()
    m.buffs = []
    m.specials_per_turn = 3

    # TODO
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

static func foundry_4_final_boss() -> Mission:
    var m = Mission.new()
    m.boss = EntityFactory.create_boss_4_f()
    m.buffs = []
    m.specials_per_turn = 3

    # TODO
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

static func foundry_final_final_boss() -> Mission:
    var m = Mission.new()
    m.boss = EntityFactory.create_boss_final()
    m.buffs = InteractableFactory.random_set()
    m.specials_per_turn = 3

    # TODO
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

static func foundry_1_floors(floor: int) -> Array:
    var specs = foundry_1_specials(floor)
    specs.shuffle()
    var ret = []
    for i in range(3):
        var m = Mission.new()
        if floor == 1:
            m.boss = EntityFactory.create_boss_1_1()
        elif floor == 2:
            m.boss = EntityFactory.create_boss_1_2()
        else:
            m.boss = EntityFactory.create_boss_1_3()
        m.specials = [specs[i], recharge_special()]
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
        if floor == 1:
            m.boss = EntityFactory.create_boss_2_1()
        elif floor == 2:
            m.boss = EntityFactory.create_boss_2_2()
        else:
            m.boss = EntityFactory.create_boss_2_3()
        m.specials = [specs[ i * 2 ], specs[i * 2 + 1]]
        m.buffs = InteractableFactory.random_set()
        m.specials_per_turn = 1
        ret.append(m)
    return ret

static func foundry_3_floors(floor: int) -> Array:
    var specs = foundry_3_specials(floor)
    specs.shuffle()
    var ret = []
    for i in range(3):
        var m = Mission.new()
        if floor == 1:
            m.boss = EntityFactory.create_boss_3_1()
        elif floor == 2:
            m.boss = EntityFactory.create_boss_3_2()
        else:
            m.boss = EntityFactory.create_boss_3_3()
        m.specials = [specs[ i * 2 ], specs[i * 2 + 1]]
        m.buffs = InteractableFactory.random_set()
        m.specials_per_turn = 2
        ret.append(m)
    return ret

static func foundry_4_floors(floor: int) -> Array:
    var specs = foundry_4_specials(floor)
    specs.shuffle()
    var ret = []
    for i in range(3):
        var m = Mission.new()
        if floor == 1:
            m.boss = EntityFactory.create_boss_4_1()
        elif floor == 2:
            m.boss = EntityFactory.create_boss_4_2()
        else:
            m.boss = EntityFactory.create_boss_4_3()
        m.specials = [specs[ i * 2 ], specs[i * 2 + 1]]
        m.buffs = InteractableFactory.random_set()
        m.specials_per_turn = 2
        ret.append(m)
    return ret

static func foundry_1_specials(floor: int) -> Array:
    var ret = []
    var s = Special.new()
    s.display_name = "Big Bot Energy"
    s.description = "Gains 2 damage"
    s.target = Special.Target.SELF
    s.shape = Special.Shape.SINGLE
    s.mechanic = Special.Mechanic.BUFF
    s.damage = 0
    s.effect = func(ent: Entity):
        ent.update_damage(2)
    s.animation_path = "res://Effects/upgrade_effect.tscn"
    ret.append(s)
        
    s = Special.new()
    s.display_name = "Comically Large Missle"
    s.description = "Deals 10 damage spread over every allied unit in a diamond tile area, centered on a random allied unit"
    s.target = Special.Target.RANDOM
    s.shape = Special.Shape.DIAMOND_3x3
    s.mechanic = Special.Mechanic.SOAK
    s.damage = 10
    s.effect = func(ent: Entity):
        return
    s.animation_path = "res://Effects/explosion_yellow.tscn"
    ret.append(s)

    s = Special.new()
    s.display_name = "Heatseaking Missles"
    s.description = "Deals 3 damage to every allied unit in a square area, centered on every allied unit"
    s.target = Special.Target.ALL
    s.shape = Special.Shape.SQUARE_3x3
    s.mechanic = Special.Mechanic.SPREAD
    s.damage = 3
    s.effect = func(ent: Entity):
        return
    s.animation_path = "res://Effects/explosion_yellow.tscn"
    ret.append(s)

    s = Special.new()
    s.display_name = "Overclock"
    s.description = "Gains 1 initiative"
    s.target = Special.Target.SELF
    s.shape = Special.Shape.SINGLE
    s.mechanic = Special.Mechanic.BUFF
    s.damage = 0
    s.effect = func(ent: Entity):
        ent.update_initiative(1)
        return
    s.animation_path = "res://Effects/upgrade_effect.tscn"
    ret.append(s)

    s = Special.new()    
    s.display_name = "Deploy Minions"
    s.description = "Deploy 3 minions with high base damage"
    s.target = Special.Target.SPAWN_CLOSE
    s.shape = Special.Shape.OCTAGON
    s.mechanic = Special.Mechanic.SPAWN
    s.spawns = [EntityFactory.create_boss_spawn_1(), EntityFactory.create_boss_spawn_1(), EntityFactory.create_boss_spawn_1()]
    ret.append(s)

    s = Special.new()
    s.display_name = "Hater Missle"
    s.description = "Deal 6 damage to the highest threat target, then remove all it's threat"
    s.target = Special.Target.THREAT
    s.shape = Special.Shape.SINGLE
    s.mechanic = Special.Mechanic.SPREAD
    s.damage = 6
    s.effect = func(ent: Entity):
        ent.setThreat(0)
        return
    s.animation_path = "res://Effects/explosion_yellow.tscn"    
    ret.append(s)
    
    s = Special.new()
    s.display_name = "Regenerative Plating"
    s.description = "Gains 10 health"
    s.target = Special.Target.SELF
    s.shape = Special.Shape.SINGLE
    s.mechanic = Special.Mechanic.BUFF
    s.damage = 0
    s.effect = func(ent: Entity):
        ent.gainHP(10)
    s.animation_path = "res://Effects/upgrade_effect.tscn"
    ret.append(s)
    
    s = Special.new()
    s.display_name = "Melting Cross Beam"
    s.description = "Deals 3 damage to a random unit and all surrounding units in a cross, reducing their armor by 1"
    s.target = Special.Target.RANDOM
    s.shape = Special.Shape.CROSS
    s.mechanic = Special.Mechanic.SPREAD
    s.damage = 3
    s.effect = func(ent: Entity):
        ent.update_armor(-1)
    s.animation_path = "res://Effects/explosion_yellow.tscn"
    ret.append(s)

    s = Special.new()
    s.display_name = "Anti-artillery missle"
    s.description = "Deals 7 damage to the farthest allied unit"
    s.target = Special.Target.RANDOM
    s.shape = Special.Shape.CROSS
    s.mechanic = Special.Mechanic.SPREAD
    s.damage = 7
    s.animation_path = "res://Effects/explosion_yellow.tscn"
    ret.append(s)
    return ret
    
static func recharge_special() -> Special:
    var s = Special.new()
    s.display_name = "Recharging"
    s.description = "Does nothing"
    s.target = Special.Target.SELF
    s.shape = Special.Shape.SINGLE
    s.mechanic = Special.Mechanic.BUFF
    s.damage = 0
    s.effect = func(ent: Entity):
        return
        
    return s

static func foundry_2_specials(floor: int) -> Array:
    return foundry_1_specials(floor)

static func foundry_3_specials(floor: int) -> Array:
    return foundry_1_specials(floor)

static func foundry_4_specials(floor: int) -> Array:
    var ret = []
    var s = Special.new()
    s.display_name = "Big Bot Energy"
    s.description = "Gains 3 damage"
    s.target = Special.Target.SELF
    s.shape = Special.Shape.SINGLE
    s.mechanic = Special.Mechanic.BUFF
    s.damage = 0
    s.effect = func(ent: Entity):
        ent.update_damage(3)
    s.animation_path = "res://Effects/upgrade_effect.tscn"
    ret.append(s)
        
    s = Special.new()
    s.display_name = "Comically Large Missle"
    s.description = "Deals 15 damage spread over every allied unit in a diamond tile area, centered on a random allied unit"
    s.target = Special.Target.RANDOM
    s.shape = Special.Shape.DIAMOND_3x3
    s.mechanic = Special.Mechanic.SOAK
    s.damage = 15
    s.effect = func(ent: Entity):
        return
    s.animation_path = "res://Effects/explosion_yellow.tscn"
    ret.append(s)

    s = Special.new()
    s.display_name = "Heatseaking Missles"
    s.description = "Deals 4 damage to every allied unit in a square area, centered on every allied unit"
    s.target = Special.Target.ALL
    s.shape = Special.Shape.SQUARE_3x3
    s.mechanic = Special.Mechanic.SPREAD
    s.damage = 4
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
    s.description = "Deploy 3 minions"
    s.target = Special.Target.SPAWN_CLOSE
    s.shape = Special.Shape.OCTAGON
    s.mechanic = Special.Mechanic.SPAWN
    s.spawns = [EntityFactory.create_boss_spawn_1(), EntityFactory.create_boss_spawn_1(), EntityFactory.create_boss_spawn_1()]
    ret.append(s)

    s = Special.new()
    s.display_name = "Hater Missle"
    s.description = "Deal 8 damage to the highest threat target, then remove all it's threat"
    s.target = Special.Target.THREAT
    s.shape = Special.Shape.SINGLE
    s.mechanic = Special.Mechanic.SPREAD
    s.damage = 8
    s.effect = func(ent: Entity):
        ent.setThreat(0)
        return
    s.animation_path = "res://Effects/explosion_yellow.tscn"    
    ret.append(s)
    
    s = Special.new()
    s.display_name = "Regenerative Plating"
    s.description = "Gains 18 health"
    s.target = Special.Target.SELF
    s.shape = Special.Shape.SINGLE
    s.mechanic = Special.Mechanic.BUFF
    s.damage = 0
    s.effect = func(ent: Entity):
        ent.gainHP(18)
    s.animation_path = "res://Effects/upgrade_effect.tscn"
    ret.append(s)
    
    s = Special.new()
    s.display_name = "Melting Cross Beam"
    s.description = "Deals 3 damage to a random unit and all surrounding units in a cross, reducing their armor by 1"
    s.target = Special.Target.RANDOM
    s.shape = Special.Shape.CROSS
    s.mechanic = Special.Mechanic.SPREAD
    s.damage = 3
    s.effect = func(ent: Entity):
        ent.update_armor(-2)
    s.animation_path = "res://Effects/explosion_yellow.tscn"
    ret.append(s)

    s = Special.new()
    s.display_name = "Anti-artillery missle"
    s.description = "Deals 10 damage to the farthest allied unit"
    s.target = Special.Target.FARTHEST
    s.shape = Special.Shape.SINGLE
    s.mechanic = Special.Mechanic.SPREAD
    s.damage = 10
    s.animation_path = "res://Effects/explosion_yellow.tscn"
    ret.append(s)
    return ret
