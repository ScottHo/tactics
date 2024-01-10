class_name InteractableFactory

static func orb_of_energy() -> Interactable:
    var inter = Interactable.new()
    inter.display_name = "Orb of Energy"
    inter.description = "When held at the start of turn, gain +1 energy per turn. Lose all energy at end of turn"
    inter.effect = func (user: Entity):
        return

    inter.drop_effect = func (user: Entity):
        return

    inter.repeated_effect = func (user: Entity):
        user.update_energy(1)
        return
    
    inter.repeated_end_effect = func (user: Entity):
        user.update_energy(-5)
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
    inter.effect = func (user: Entity):
        inter.counter = 0
        return

    inter.drop_effect = func (user: Entity):
        user.update_damage(-inter.counter)
        user.update_armor(inter.counter)
        inter.counter = 0
        return

    inter.repeated_effect = func (user: Entity):
        user.update_armor(-1)
        user.update_damage(1)
        inter.counter += 1
        return
    
    inter.repeated_end_effect = func (user: Entity):
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
    inter.effect = func (user: Entity):
        user.update_movement(-3)
        return

    inter.drop_effect = func (user: Entity):
        user.update_movement(3)
        return

    inter.repeated_effect = func (user: Entity):
        user.gainHP(5)
        return
    
    inter.repeated_end_effect = func (user: Entity):
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
    inter.effect = func (user: Entity):
        return

    inter.drop_effect = func (user: Entity):
        return

    inter.repeated_effect = func (user: Entity):
        user.update_damage(1)
        return
    
    inter.repeated_end_effect = func (user: Entity):
        user.loseHP(3)
        return

    inter.storable = true
    inter.sprite_path = "res://interactable_sprite.tscn"
    inter.icon_path = "res://Assets/orb.png"
    inter.color = Color.DIM_GRAY
    return inter

static func random_set():
    var ret = [orb_of_destruction(), orb_of_energy(), orb_of_roots(), orb_of_sacrifice()]
    ret.shuffle()
    return ret
