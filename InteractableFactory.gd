class_name InteractableFactory

static func orb_of_energy() -> Interactable:
    var inter = Interactable.new()
    inter.display_name = "Orb of Energy"
    inter.description = "When held at the start of turn, gain +1 energy per turn. Lose all energy at end of turn"
    inter.effect = func (_user: Entity):
        return

    inter.drop_effect = func (_user: Entity):
        return

    inter.repeated_effect = func (_user: Entity):
        _user.update_energy(1)
        return
    
    inter.repeated_end_effect = func (_user: Entity):
        _user.update_energy(-5)
        return

    inter.storable = true
    inter.sprite_path = "res://interactable_sprite.tscn"
    inter.icon_path = "res://Assets/orb.png"
    inter.color = Color.ROYAL_BLUE
    return inter

static func orb_of_destruction() -> Interactable:
    var inter = Interactable.new()
    inter.display_name = "Orb of Destruction"
    inter.description = "When held at the start of turn, gain +1 damage and -1 armor every turn. Total effects are reversed when dropped"
    inter.effect = func (_user: Entity):
        inter.counter = 0
        return

    inter.drop_effect = func (_user: Entity):
        _user.update_damage(-inter.counter)
        _user.update_armor(inter.counter)
        inter.counter = 0
        return

    inter.repeated_effect = func (_user: Entity):
        _user.update_armor(-1)
        _user.update_damage(1)
        inter.counter += 1
        return
    
    inter.repeated_end_effect = func (_user: Entity):
        return

    inter.storable = true
    inter.sprite_path = "res://interactable_sprite.tscn"
    inter.icon_path = "res://Assets/orb.png"
    inter.color = Color.DARK_RED
    return inter

static func orb_of_roots() -> Interactable:
    var inter = Interactable.new()
    inter.display_name = "Orb of Roots"
    inter.description = "When held at the start of a turn, gain 5 health. Lose 3 movement"
    inter.effect = func (_user: Entity):
        _user.update_movement(-3)
        return

    inter.drop_effect = func (_user: Entity):
        _user.update_movement(3)
        return

    inter.repeated_effect = func (_user: Entity):
        _user.gainHP(5)
        return
    
    inter.repeated_end_effect = func (_user: Entity):
        return

    inter.storable = true
    inter.sprite_path = "res://interactable_sprite.tscn"
    inter.icon_path = "res://Assets/orb.png"
    inter.color = Color.WEB_GREEN
    return inter

static func orb_of_sacrifice() -> Interactable:
    var inter = Interactable.new()
    inter.display_name = "Orb of Sacrifice"
    inter.description = "When held at the end of a turn, lose 3 health. When held at the start of a turn, gain 1 damage"
    inter.effect = func (_user: Entity):
        return

    inter.drop_effect = func (_user: Entity):
        return

    inter.repeated_effect = func (_user: Entity):
        _user.update_damage(1)
        return
    
    inter.repeated_end_effect = func (_user: Entity):
        _user.loseHP(3)
        return

    inter.storable = true
    inter.sprite_path = "res://interactable_sprite.tscn"
    inter.icon_path = "res://Assets/orb.png"
    inter.color = Color.DIM_GRAY
    return inter

static func bronze_soul() -> Interactable:
    var inter = Interactable.new()
    inter.display_name = "Bronze Soul"
    inter.description = "Lose 3 hp on pick up and the start of every turn when held"
    inter.effect = func (_user: Entity):
        _user.loseHP(3)
        return

    inter.drop_effect = func (_user: Entity):
        return

    inter.repeated_effect = func (_user: Entity):
        _user.loseHP(3)
        return
    
    inter.repeated_end_effect = func (_user: Entity):
        return

    inter.storable = true
    inter.sprite_path = "res://interactable_sprite.tscn"
    inter.icon_path = "res://Assets/Objects/soul.png"
    inter.color = Color.SADDLE_BROWN
    return inter

static func add_drainer() -> Interactable:
    var inter = Interactable.new()
    inter.display_name = "Deteriorating"
    inter.description = "Lose 1 HP"
    inter.effect = func (_user: Entity):
        return

    inter.drop_effect = func (_user: Entity):
        return

    inter.repeated_effect = func (_user: Entity):
        return
    
    inter.repeated_end_effect = func (_user: Entity):
        _user.loseHP(1)
        return

    inter.storable = true
    return inter

static func add_cursed_gift() -> Interactable:
    var inter = Interactable.new()
    inter.display_name = "Cursed Gift"
    inter.description = "Get +1 Damage and -1 Armor"
    inter.effect = func (_user: Entity):
        _user.update_damage(1)
        _user.update_armor(-1)
        return

    inter.drop_effect = func (_user: Entity):
        _user.update_damage(-1)
        _user.update_armor(1)
        return

    inter.repeated_effect = func (_user: Entity):
        return
    
    inter.repeated_end_effect = func (_user: Entity):
        return

    inter.storable = true
    inter.sprite_path = "res://interactable_sprite.tscn"
    inter.icon_path = "res://Assets/Objects/cursed_gift.png"
    inter.color = Color.WHITE
    return inter

static func random_set():
    var ret = [orb_of_destruction(), orb_of_energy(), orb_of_roots(), orb_of_sacrifice()]
    ret.shuffle()
    return ret
