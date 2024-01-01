class_name MissionFactory

static func mission_1():
    var m = Mission.new()
    m.display_name = "Mission 1"
    m.description = "Kill the boss"
    m.boss = EntityFactory.create_boss_1()
    
    
    m.buffs = [InteractableFactory.create_blue_orb_thing()]
    
    var s1 = Special.new()
    s1.display_name = "Big Electric Blast"
    s1.description = "Deals 4 damage spread over every allied unit in a 3x3 area centered on a random allied unit"
    s1.target = Special.Target.RANDOM
    s1.shape = Special.Shape.SQUARE_3x3
    s1.mechanic = Special.Mechanic.SOAK
    s1.damage = 4
    s1.effect = func(ent: Entity):
        return

    var s2 = Special.new()
    s2.display_name = "Missles For Everyone"
    s2.description = "Deals 1 damage to every allied unit in a 3x3 area, centered on every allied unit"
    s2.target = Special.Target.ALL
    s2.shape = Special.Shape.SQUARE_3x3
    s2.mechanic = Special.Mechanic.SPREAD
    s2.damage = 1
    s2.effect = func(ent: Entity):
        return
    
    m.specials = [s1, s2]
    return m

static func mission_2():
    var m = Mission.new()
    m.display_name = "Mission 1"
    m.description = "Kill the boss"
    m.boss = EntityFactory.create_boss_2()
    
    m.buffs = [InteractableFactory.create_blue_orb_thing()]
    
    var s1 = Special.new()
    s1.display_name = "Ramp up"
    s1.description = "Gains 1 initiative"
    s1.target = Special.Target.SELF
    s1.shape = Special.Shape.SINGLE
    s1.mechanic = Special.Mechanic.BUFF
    s1.damage = 0
    s1.effect = func(ent: Entity):
        ent.update_initiative(1)

    var s2 = Special.new()
    s2.display_name = "Big bot energy"
    s2.description = "Gains 1 damage"
    s2.target = Special.Target.SELF
    s2.shape = Special.Shape.SINGLE
    s2.mechanic = Special.Mechanic.BUFF
    s2.damage = 0
    s2.effect = func(ent: Entity):
        ent.update_damage(1)
    
    m.specials = [s1, s2]
    return m

static func mission_3():
    var m = Mission.new()
    m.display_name = "Mission 1"
    m.description = "Kill the boss"
    m.boss = EntityFactory.create_boss_3()
    
    
    m.buffs = [InteractableFactory.create_blue_orb_thing()]
    
    var s1 = Special.new()
    s1.display_name = "Massive Nuke"
    s1.description = "Deals 10 damage spread over every allied unit in a 13 area, centered on a random allied unit"
    s1.target = Special.Target.RANDOM
    s1.shape = Special.Shape.DIAMOND_3x3
    s1.mechanic = Special.Mechanic.SOAK
    s1.damage = 10
    s1.effect = func(ent: Entity):
        return

    var s2 = Special.new()
    s2.display_name = "Widespread destruction"
    s2.description = "Deals 2 damage to every allied unit in a 13 square area, centered on every allied unit"
    s2.target = Special.Target.ALL
    s2.shape = Special.Shape.DIAMOND_3x3
    s2.mechanic = Special.Mechanic.SPREAD
    s2.damage = 2
    s2.effect = func(ent: Entity):
        return

    var s3 = Special.new()
    s3.display_name = "Big Bot Energy"
    s3.description = "Gains 1 initiative and 1 damage"
    s3.target = Special.Target.SELF
    s3.shape = Special.Shape.SINGLE
    s3.mechanic = Special.Mechanic.BUFF
    s3.damage = 0
    s3.effect = func(ent: Entity):
        ent.update_initiative(1)
        ent.update_damage(1)

    
    m.specials = [s1, s2]
    return m
