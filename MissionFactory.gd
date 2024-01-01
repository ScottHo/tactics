class_name MissionFactory

static func mission_1():
    var m = Mission.new()
    m.display_name = "Mission 1"
    m.description = "Kill the boss"
    m.boss = EntityFactory.create_boss_1()
    
    
    m.buffs = [InteractableFactory.create_blue_orb_thing()]
    
    var s1 = Special.new()
    s1.display_name = "Big Electric Blast"
    s1.description = "Deals 4 damage spread over everyfriendly unit in a 3x3 area centered on a random friendly unit"
    s1.target = Special.Target.RANDOM
    s1.shape = Special.Shape.SQUARE_3x3
    s1.mechanic = Special.Mechanic.SOAK
    s1.damage = 4

    var s2 = Special.new()
    s2.display_name = "Missles For Everyone"
    s2.description = "Deals 1 damage to every friendly unit in a 3x3 area centered on every friendly unit"
    s2.target = Special.Target.ALL
    s2.shape = Special.Shape.SQUARE_3x3
    s2.mechanic = Special.Mechanic.SPREAD
    s2.damage = 1
    
    m.specials = [s1, s2]
    return m

static func mission_2():
    return mission_1()

static func mission_3():
    return mission_1()
