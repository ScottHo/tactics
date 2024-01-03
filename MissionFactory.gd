class_name MissionFactory

static func mission_1():
    var m = Mission.new()
    m.display_name = "Mission 1"
    m.description = "Kill the boss."
    m.boss = EntityFactory.create_boss_1()
    
    
    m.buffs = [InteractableFactory.create_blue_orb_thing()]
    
    var s1 = Special.new()
    s1.display_name = "Big Bot Energy"
    s1.description = "Gains 1 initiative, 1 movement, and 1 damage"
    s1.target = Special.Target.SELF
    s1.shape = Special.Shape.SINGLE
    s1.mechanic = Special.Mechanic.BUFF
    s1.damage = 0
    s1.effect = func(ent: Entity):
        ent.update_initiative(1)
        ent.update_movement(1)
        ent.update_damage(1)

    m.specials = [s1]
    return m

static func mission_2():
    var m = Mission.new()
    m.display_name = "Mission 2"
    m.description = "Kill the boss."
    m.boss = EntityFactory.create_boss_2()
    
    m.buffs = [InteractableFactory.create_blue_orb_thing()]

    var s1 = Special.new()
    s1.display_name = "Hater Missle"
    s1.description = "Deal 12 damage to the highest threat target, then removing all it's threat"
    s1.target = Special.Target.THREAT
    s1.shape = Special.Shape.SINGLE
    s1.mechanic = Special.Mechanic.SPREAD
    s1.damage = 12
    s1.effect = func(ent: Entity):
        ent.setThreat(0)
        return

    var s2 = Special.new()    
    s2.display_name = "Deploy Minions"
    s2.description = "Deploy 3 minions with high base damage"
    s2.target = Special.Target.SPAWN_CLOSE
    s2.shape = Special.Shape.OCTAGON
    s2.mechanic = Special.Mechanic.SPAWN
    s2.spawns = [EntityFactory.create_boss_spawn_1(), EntityFactory.create_boss_spawn_1(),
            EntityFactory.create_boss_spawn_1()]
    
    m.specials = [s1, s2]
    return m

static func mission_3():
    var m = Mission.new()
    m.display_name = "Mission 3"
    m.description = "Kill the boss."
    m.boss = EntityFactory.create_boss_3()
    
    m.buffs = [InteractableFactory.create_blue_orb_thing()]
    
    var s1 = Special.new()
    s1.display_name = "Massive Nuke"
    s1.description = "Deals 21 damage spread over every allied unit in a diamond tile area, centered on a random allied unit"
    s1.target = Special.Target.RANDOM
    s1.shape = Special.Shape.DIAMOND_3x3
    s1.mechanic = Special.Mechanic.SOAK
    s1.damage = 21
    s1.effect = func(ent: Entity):
        return

    var s2 = Special.new()
    s2.display_name = "Widespread destruction"
    s2.description = "Deals 7 damage to every allied unit in a square area, centered on every allied unit"
    s2.target = Special.Target.ALL
    s2.shape = Special.Shape.SQUARE_3x3
    s2.mechanic = Special.Mechanic.SPREAD
    s2.damage = 7
    s2.effect = func(ent: Entity):
        return

    var s3 = Special.new()
    s3.display_name = "Overclock"
    s3.description = "Gains 2 initiative"
    s3.target = Special.Target.SELF
    s3.shape = Special.Shape.SINGLE
    s3.mechanic = Special.Mechanic.BUFF
    s3.damage = 0
    s3.effect = func(ent: Entity):
        ent.update_initiative(2)

    
    m.specials = [s1, s2, s3]
    return m
