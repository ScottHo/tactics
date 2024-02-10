class_name MissionFactory

static func tutorial_boss() -> Mission:
    # Spread, Soak, Revivable Minions
    var m = Mission.new()
    m.boss = EntityFactory.create_tutorial_boss()
    m.buffs = []
    m.specials_per_turn = 1
    m.is_tutorial = true

    var s1 = Special.new()
    s1.display_name = "Cursed Gift"
    s1.description = "Spawn a cursed gift. Picking it up grants +1 damage, but -1 armor"
    s1.target = Special.Target.SPAWN_CLOSE
    s1.shape = Special.Shape.OCTAGON
    s1.mechanic = Special.Mechanic.SPAWN
    s1.spawns = [InteractableFactory.add_cursed_gift()]

    var s2 = Special.new()
    s2.display_name = "Heal Up"
    s2.description = "Heal 10 health"
    s2.target = Special.Target.SELF
    s2.shape = Special.Shape.SINGLE
    s2.mechanic = Special.Mechanic.BUFF
    s2.damage = 0
    s2.effect = func(_ent: Entity):
        _ent.gainHP(10)
    m.specials = [s1,s2]
    return m

static func foundry_1_final_boss() -> Mission:
    # Spread, Soak, Revivable Minions
    var m = Mission.new()
    m.boss = EntityFactory.create_boss_1_f()
    m.buffs = []
    m.specials_per_turn = 2

    var s1 = Special.new()
    s1.display_name = "Summon Bronze Souls"
    s1.description = "Deploy 2 minions that spawn Bronze Souls on death"
    s1.target = Special.Target.SPAWN_CLOSE
    s1.shape = Special.Shape.OCTAGON
    s1.mechanic = Special.Mechanic.SPAWN
    s1.spawns = [EntityFactory.create_boss_spawn_1_f(), EntityFactory.create_boss_spawn_1_f()]

    var s2 = Special.new()
    s2.display_name = "Bronze Missles"
    s2.description = "Deals 4 damage to every allied unit in a square area, centered on every allied unit"
    s2.target = Special.Target.ALL
    s2.shape = Special.Shape.SQUARE_3x3
    s2.mechanic = Special.Mechanic.SPREAD
    s2.damage = 4
    s2.effect = func(_ent: Entity):
        return
    s2.animation_path = "res://Effects/explosion_yellow.tscn"

    var s3 = Special.new()
    s3.display_name = "Bronze Age"
    s3.description = "For every bronze soul on the ground, create a minion"
    s3.target = Special.Target.INTERACTABLES
    s3.shape = Special.Shape.SINGLE
    s3.mechanic = Special.Mechanic.SPAWN
    s3.target_interactable = "Bronze Soul"
    s3.spawns = [EntityFactory.create_boss_spawn_1_f()]

    var s4 = Special.new()
    s4.display_name = "Bronze Hammer"
    s4.description = "Deals 12 damage spread over every allied unit in a diamond area, centered on a random allied unit"
    s4.target = Special.Target.RANDOM
    s4.shape = Special.Shape.DIAMOND_3x3
    s4.mechanic = Special.Mechanic.SOAK
    s4.damage = 12
    s4.effect = func(_ent: Entity):
        return
    s4.animation_path = "res://Effects/explosion_yellow.tscn"

    m.specials = [s1,s2,s3,s4]
    return m

static func foundry_2_final_boss() -> Mission:
    var m = Mission.new()
    m.display_name = "Foundry 2F"
    m.boss = EntityFactory.create_boss_2_f()
    m.buffs = []
    m.specials_per_turn = 2

    var s1 = Special.new()    
    s1.display_name = "Iron Quake"
    s1.description = "Strike the floor, causing tiles under allied units to crack and all brevious cracked tiles to break"
    s1.target = Special.Target.ALL
    s1.shape = Special.Shape.SINGLE
    s1.mechanic = Special.Mechanic.DESTROY_TILE

    var s2 = Special.new()    
    s2.display_name = "Iron Shackles"
    s2.description = "Shackle two random allied units, reducing their movement by 1"
    s2.target = Special.Target.RANDOM2
    s2.shape = Special.Shape.SINGLE
    s2.mechanic = Special.Mechanic.SPREAD
    s2.effect = func(_ent: Entity):
        _ent.update_movement(-1)
    
    var s3 = Special.new()    
    s3.display_name = "Iron Quake"
    s3.description = "Strike the floor, causing tiles under allied units to crack and all brevious cracked tiles to break"
    s3.target = Special.Target.ALL
    s3.shape = Special.Shape.SINGLE
    s3.mechanic = Special.Mechanic.DESTROY_TILE

    var s4 = Special.new()    
    s4.display_name = "Cross "
    s4.description = "Deals 5 damage to every allied unit in a cross area, centered on every allied unit"
    s4.target = Special.Target.ALL
    s4.shape = Special.Shape.CROSS
    s4.mechanic = Special.Mechanic.SPREAD
    s4.damage = 5
    s4.animation_path = "res://Effects/explosion_yellow.tscn"

    m.specials = [s1, s2, s3, s4]
    return m

static func foundry_3_final_boss() -> Mission:
    var m = Mission.new()
    m.boss = EntityFactory.create_boss_3_f()
    m.buffs = []
    m.specials_per_turn = 2

    var s1 = Special.new()    
    s1.display_name = "Dice floor"
    s1.description = "Switches the dice on the floor"
    s1.target = Special.Target.SELF
    s1.shape = Special.Shape.SINGLE
    s1.mechanic = Special.Mechanic.CHANGE_TILE_DICE

    var s2 = Special.new()    
    s2.display_name = "Roll the dice: Damage"
    s2.description = "Roll the dice. Deal 2x the damage to a random target"
    s2.target = Special.Target.RANDOM
    s2.shape = Special.Shape.SINGLE
    s2.mechanic = Special.Mechanic.SPREAD
    s2.effect = func(_ent: Entity, roll: int):
        _ent.loseHP(roll*2)

    var s3 = Special.new()
    s3.display_name = "Dice trap"
    s3.description = "Deals damage to every allied unit in a square area, centered on every tile with a dice faces. The damage is equal to 2x the dice face"
    s3.target = Special.Target.TILE_DICE
    s3.shape = Special.Shape.SQUARE_3x3
    s3.mechanic = Special.Mechanic.SPREAD
    s3.animation_path = "res://Effects/explosion_yellow.tscn"
    
    var s4 = Special.new()    
    s4.display_name = "Roll the dice: Minions"
    s4.description = "Roll the dice and create that many Dice Minions"
    s4.target = Special.Target.SELF
    s4.shape = Special.Shape.OCTAGON
    s4.mechanic = Special.Mechanic.SPAWN_DICE
    s4.spawns = [EntityFactory.create_boss_spawn_3(), EntityFactory.create_boss_spawn_3(), EntityFactory.create_boss_spawn_3(),
    EntityFactory.create_boss_spawn_3(), EntityFactory.create_boss_spawn_3(), EntityFactory.create_boss_spawn_3()]

    var s5 = Special.new()
    s5.display_name = "Box Cars"
    s5.description = "Deal 12 damage to every allied unit. If the unit is on a dice face, take the damage on the dice face instead"
    s5.target = Special.Target.SELF
    s5.shape = Special.Shape.SINGLE
    s5.mechanic = Special.Mechanic.SPREAD
    s5.damage = 0
    s5.effect = func(_ent: Entity, on_tile: int = -1):
        if on_tile == -1:
            _ent.loseHP(12)
        else:
            _ent.loseHP(on_tile)
    s5.animation_path = "res://Effects/explosion_yellow.tscn"
    
    var s6 = Special.new()
    s6.display_name = "Roll the dice: Buff"
    s6.description = "Roll the dice for an effect. 1: gain 1 HP, 2: gain 1 movement, 3: gain 1 damage, 4: gain 1 armor, 5: gain 1 initiative, 6: All"
    s6.target = Special.Target.SELF
    s6.shape = Special.Shape.SINGLE
    s6.mechanic = Special.Mechanic.BUFF
    s6.effect = func(_ent: Entity, roll: int):
        if roll == 1:
            _ent.gainHP(1)
        if roll == 2:
            _ent.update_movement(1)
        if roll == 3:
            _ent.update_damage(1)
        if roll == 4:
            _ent.update_armor(1)
        if roll == 5:
            _ent.update_initiative(1)
        if roll == 6:
            _ent.gainHP(1)
            _ent.update_movement(1)
            _ent.update_damage(1)
            _ent.update_armor(1)
            _ent.update_initiative(1)
    
    m.specials = [s1, s2, s3, s4, s5, s2]
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
    s2.effect = func(_ent: Entity):
        _ent.setThreat(0)
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
    s2.effect = func(_ent: Entity):
        _ent.setThreat(0)
        return
    s2.animation_path = "res://Effects/explosion_yellow.tscn"
    
    m.specials = [s1, s2]
    return m

static func foundry_1_floors(_floor: int) -> Array:
    var specs = foundry_1_specials()
    specs.shuffle()
    var ret = []
    for i in range(6):
        var m = Mission.new()
        if _floor == 1:
            m.boss = EntityFactory.create_boss_1_1()
            m.specials_per_turn = 0
            m.specials = []
        if _floor == 2:
            m.boss = EntityFactory.create_boss_1_2()
            m.specials_per_turn = 1
            m.specials = [specs[i], recharge_special()]
        if _floor == 3:
            m.boss = EntityFactory.create_boss_1_3()
            m.specials_per_turn = 1
            m.specials = [specs[i], specs[i+1]]
        if _floor == 4:
            m.boss = EntityFactory.create_boss_1_4()
            m.specials_per_turn = 2
            m.specials = [specs[i], specs[i+1]]
        if _floor == 5:
            m.boss = EntityFactory.create_boss_1_5()
            m.specials_per_turn = 2
            m.specials = [specs[i], specs[i+1]]
        if _floor == 6:
            m.boss = EntityFactory.create_boss_1_6()
            m.specials_per_turn = 2
            m.specials = [specs[i], specs[i+1]]
        m.buffs = []
        ret.append(m)
    return ret

static func foundry_2_floors(_floor: int) -> Array:
    var specs = foundry_1_specials()
    specs.shuffle()
    var ret = []
    for i in range(3):
        var m = Mission.new()
        if _floor == 1:
            m.boss = EntityFactory.create_boss_2_1()
        if _floor == 2:
            m.boss = EntityFactory.create_boss_2_2()
        if _floor == 3:
            m.boss = EntityFactory.create_boss_2_3()
        if _floor == 4:
            m.boss = EntityFactory.create_boss_2_4()
        if _floor == 5:
            m.boss = EntityFactory.create_boss_2_5()
        if _floor == 6:
            m.boss = EntityFactory.create_boss_2_6()
        m.specials = [specs[i], specs[i+1], specs[i+2], specs[i+3]]
        m.buffs = InteractableFactory.random_set()
        m.specials_per_turn = 2
        ret.append(m)
    return ret

static func foundry_3_floors(_floor: int) -> Array:
    var specs = foundry_3_specials()
    specs.shuffle()
    var ret = []
    for i in range(3):
        var m = Mission.new()
        if _floor == 1:
            m.boss = EntityFactory.create_boss_3_1()
        elif _floor == 2:
            m.boss = EntityFactory.create_boss_3_2()
        else:
            m.boss = EntityFactory.create_boss_3_3()
        m.specials = [specs[ i * 2 ], specs[i * 2 + 1]]
        m.buffs = InteractableFactory.random_set()
        m.specials_per_turn = 2
        ret.append(m)
    return ret

static func foundry_4_floors(_floor: int) -> Array:
    var specs = foundry_4_specials()
    specs.shuffle()
    var ret = []
    for i in range(3):
        var m = Mission.new()
        if _floor == 1:
            m.boss = EntityFactory.create_boss_4_1()
        elif _floor == 2:
            m.boss = EntityFactory.create_boss_4_2()
        else:
            m.boss = EntityFactory.create_boss_4_3()
        m.specials = [specs[ i * 2 ], specs[i * 2 + 1]]
        m.buffs = InteractableFactory.random_set()
        m.specials_per_turn = 2
        ret.append(m)
    return ret

static func recharge_special() -> Special:
    var s = Special.new()
    s.display_name = "Do Nothing"
    s.description = "Does nothing. Seriously."
    s.target = Special.Target.SELF
    s.shape = Special.Shape.SINGLE
    s.mechanic = Special.Mechanic.BUFF
    s.damage = 0
    s.effect = func(_ent: Entity):
        return
    return s

static func foundry_1_specials() -> Array:
    var ret = []
    var s = Special.new()
    s.display_name = "Big Bot Energy"
    s.description = "Gains 1 damage"
    s.target = Special.Target.SELF
    s.shape = Special.Shape.SINGLE
    s.mechanic = Special.Mechanic.BUFF
    s.damage = 0
    s.effect = func(_ent: Entity):
        _ent.update_damage(1)
    s.animation_path = "res://Effects/upgrade_effect.tscn"
    ret.append(s)
        
    s = Special.new()
    s.display_name = "Comically Large Missle"
    s.description = "Deals 10 damage spread over every allied unit in a diamond tile area, centered on a random allied unit, rounded down"
    s.target = Special.Target.RANDOM
    s.shape = Special.Shape.DIAMOND_3x3
    s.mechanic = Special.Mechanic.SOAK
    s.damage = 10
    s.animation_path = "res://Effects/explosion_yellow.tscn"
    ret.append(s)

    s = Special.new()
    s.display_name = "Heatseaking Missles"
    s.description = "Deals 3 damage to every allied unit in a square area, centered on every allied unit"
    s.target = Special.Target.ALL
    s.shape = Special.Shape.SQUARE_3x3
    s.mechanic = Special.Mechanic.SPREAD
    s.damage = 3
    s.animation_path = "res://Effects/explosion_yellow.tscn"
    ret.append(s)

    s = Special.new()
    s.display_name = "Overclock"
    s.description = "Gains 1 initiative"
    s.target = Special.Target.SELF
    s.shape = Special.Shape.SINGLE
    s.mechanic = Special.Mechanic.BUFF
    s.damage = 0
    s.effect = func(_ent: Entity):
        _ent.update_initiative(1)
        return
    s.animation_path = "res://Effects/upgrade_effect.tscn"
    ret.append(s)

    s = Special.new()    
    s.display_name = "Deploy Minions"
    s.description = "Deploy 3 minions with 8 health and 3 damage"
    s.target = Special.Target.SPAWN_CLOSE
    s.shape = Special.Shape.OCTAGON
    s.mechanic = Special.Mechanic.SPAWN
    s.spawns = [EntityFactory.create_boss_spawn_1(), EntityFactory.create_boss_spawn_1(), EntityFactory.create_boss_spawn_1()]
    ret.append(s)

    s = Special.new()
    s.display_name = "Hater Missle"
    s.description = "Deal 5 damage to the highest threat target, then remove all it's threat"
    s.target = Special.Target.THREAT
    s.shape = Special.Shape.SINGLE
    s.mechanic = Special.Mechanic.SPREAD
    s.damage = 5
    s.effect = func(_ent: Entity):
        _ent.setThreat(0)
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
    s.effect = func(_ent: Entity):
        _ent.gainHP(10)
    s.animation_path = "res://Effects/upgrade_effect.tscn"
    ret.append(s)
    
    s = Special.new()
    s.display_name = "Melting Cross Beam"
    s.description = "Deals 3 damage to a random unit and all surrounding units in a cross, reducing their armor by 1"
    s.target = Special.Target.RANDOM
    s.shape = Special.Shape.CROSS
    s.mechanic = Special.Mechanic.SPREAD
    s.damage = 3
    s.effect = func(_ent: Entity):
        _ent.update_armor(-1)
    s.animation_path = "res://Effects/explosion_yellow.tscn"
    ret.append(s)

    s = Special.new()
    s.display_name = "Anti-artillery missle"
    s.description = "Deals 6 damage to the farthest allied unit"
    s.target = Special.Target.RANDOM
    s.shape = Special.Shape.SINGLE
    s.mechanic = Special.Mechanic.SPREAD
    s.damage = 6
    s.animation_path = "res://Effects/explosion_yellow.tscn"
    ret.append(s)

    s.display_name = "Harden"
    s.description = "Gains 1 armor"
    s.target = Special.Target.SELF
    s.shape = Special.Shape.SINGLE
    s.mechanic = Special.Mechanic.BUFF
    s.damage = 0
    s.effect = func(_ent: Entity):
        _ent.update_armor(1)
    s.animation_path = "res://Effects/upgrade_effect.tscn"
    ret.append(s)
    
    s = Special.new()    
    s.display_name = "Spawn Big Guy"
    s.description = "Deploy 1 minions with 18 health and 5 damage"
    s.target = Special.Target.SPAWN_CLOSE
    s.shape = Special.Shape.OCTAGON
    s.mechanic = Special.Mechanic.SPAWN
    s.spawns = [EntityFactory.create_boss_spawn_1_b()]
    ret.append(s)
    return ret

static func foundry_2_specials() -> Array:
    var ret = []
    var s = Special.new()
    s.display_name = "Big Bot Energy"
    s.description = "Gains 2 damage"
    s.target = Special.Target.SELF
    s.shape = Special.Shape.SINGLE
    s.mechanic = Special.Mechanic.BUFF
    s.damage = 0
    s.effect = func(_ent: Entity):
        _ent.update_damage(2)
    s.animation_path = "res://Effects/upgrade_effect.tscn"
    ret.append(s)
        
    s = Special.new()
    s.display_name = "Comically Large Missle"
    s.description = "Deals 12 damage spread over every allied unit in a diamond tile area, centered on a random allied unit"
    s.target = Special.Target.RANDOM
    s.shape = Special.Shape.DIAMOND_3x3
    s.mechanic = Special.Mechanic.SOAK
    s.damage = 12
    s.animation_path = "res://Effects/explosion_yellow.tscn"
    ret.append(s)

    s = Special.new()
    s.display_name = "Heatseaking Missles"
    s.description = "Deals 4 damage to every allied unit in a square area, centered on every allied unit"
    s.target = Special.Target.ALL
    s.shape = Special.Shape.SQUARE_3x3
    s.mechanic = Special.Mechanic.SPREAD
    s.damage = 4
    s.animation_path = "res://Effects/explosion_yellow.tscn"
    ret.append(s)

    s = Special.new()
    s.display_name = "Overclock"
    s.description = "Gains 2 initiative"
    s.target = Special.Target.SELF
    s.shape = Special.Shape.SINGLE
    s.mechanic = Special.Mechanic.BUFF
    s.damage = 0
    s.effect = func(_ent: Entity):
        _ent.update_initiative(2)
        return
    s.animation_path = "res://Effects/upgrade_effect.tscn"
    ret.append(s)

    s = Special.new()    
    s.display_name = "Deploy Minions"
    s.description = "Deploy 3 minions with 12 health and 4 damage"
    s.target = Special.Target.SPAWN_CLOSE
    s.shape = Special.Shape.OCTAGON
    s.mechanic = Special.Mechanic.SPAWN
    s.spawns = [EntityFactory.create_boss_spawn_2(), EntityFactory.create_boss_spawn_2(), EntityFactory.create_boss_spawn_2()]
    ret.append(s)

    s = Special.new()
    s.display_name = "Hater Missle"
    s.description = "Deal 7 damage to the highest threat target, then remove all it's threat"
    s.target = Special.Target.THREAT
    s.shape = Special.Shape.SINGLE
    s.mechanic = Special.Mechanic.SPREAD
    s.damage = 7
    s.effect = func(_ent: Entity):
        _ent.setThreat(0)
        return
    s.animation_path = "res://Effects/explosion_yellow.tscn"    
    ret.append(s)
    
    s = Special.new()
    s.display_name = "Regenerative Plating"
    s.description = "Gains 20 health"
    s.target = Special.Target.SELF
    s.shape = Special.Shape.SINGLE
    s.mechanic = Special.Mechanic.BUFF
    s.damage = 0
    s.effect = func(_ent: Entity):
        _ent.gainHP(20)
    s.animation_path = "res://Effects/upgrade_effect.tscn"
    ret.append(s)
    
    s = Special.new()
    s.display_name = "Melting Cross Beam"
    s.description = "Deals 4 damage to a random unit and all surrounding units in a cross, reducing their armor by 2"
    s.target = Special.Target.RANDOM
    s.shape = Special.Shape.CROSS
    s.mechanic = Special.Mechanic.SPREAD
    s.damage = 4
    s.effect = func(_ent: Entity):
        _ent.update_armor(-2)
    s.animation_path = "res://Effects/explosion_yellow.tscn"
    ret.append(s)

    s = Special.new()
    s.display_name = "Anti-artillery missle"
    s.description = "Deals 8 damage to the farthest allied unit"
    s.target = Special.Target.RANDOM
    s.shape = Special.Shape.CROSS
    s.mechanic = Special.Mechanic.SPREAD
    s.damage = 5
    s.animation_path = "res://Effects/explosion_yellow.tscn"
    ret.append(s)
    
    s = Special.new()    
    s.display_name = "Spawn Big Guy"
    s.description = "Deploy 1 minion with 25 health and 6 damage"
    s.target = Special.Target.SPAWN_CLOSE
    s.shape = Special.Shape.OCTAGON
    s.mechanic = Special.Mechanic.SPAWN
    s.spawns = [EntityFactory.create_boss_spawn_2_b(),]
    ret.append(s)
    return ret

static func foundry_3_specials() -> Array:
    return foundry_2_specials()

static func foundry_4_specials() -> Array:
    var ret = []
    var s = Special.new()
    s.display_name = "Big Bot Energy"
    s.description = "Gains 3 damage"
    s.target = Special.Target.SELF
    s.shape = Special.Shape.SINGLE
    s.mechanic = Special.Mechanic.BUFF
    s.damage = 0
    s.effect = func(_ent: Entity):
        _ent.update_damage(3)
    s.animation_path = "res://Effects/upgrade_effect.tscn"
    ret.append(s)
        
    s = Special.new()
    s.display_name = "Comically Large Missle"
    s.description = "Deals 15 damage spread over every allied unit in a diamond tile area, centered on a random allied unit"
    s.target = Special.Target.RANDOM
    s.shape = Special.Shape.DIAMOND_3x3
    s.mechanic = Special.Mechanic.SOAK
    s.damage = 15
    s.effect = func(_ent: Entity):
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
    s.effect = func(_ent: Entity):
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
    s.effect = func(_ent: Entity):
        _ent.update_initiative(2)
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
    s.effect = func(_ent: Entity):
        _ent.setThreat(0)
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
    s.effect = func(_ent: Entity):
        _ent.gainHP(18)
    s.animation_path = "res://Effects/upgrade_effect.tscn"
    ret.append(s)
    
    s = Special.new()
    s.display_name = "Melting Cross Beam"
    s.description = "Deals 3 damage to a random unit and all surrounding units in a cross, reducing their armor by 1"
    s.target = Special.Target.RANDOM
    s.shape = Special.Shape.CROSS
    s.mechanic = Special.Mechanic.SPREAD
    s.damage = 3
    s.effect = func(_ent: Entity):
        _ent.update_armor(-2)
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
