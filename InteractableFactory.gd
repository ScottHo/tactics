class_name InteractableFactory

static func create_blue_orb_thing() -> Interactable:
    var inter = Interactable.new()
    inter.display_name = "Blue Orb Buff Thing"
    inter.description = "Pick up for +4 damage, but -4 movement"
    inter.effect = func (user: Entity):
        user.damage_modifier += 4
        user.movement_modifier -= 4
        return

    inter.drop_effect = func (user: Entity):
        user.damage_modifier -= 4
        user.movement_modifier += 4
        return

    inter.repeated_effect = func (user: Entity):
        print("repeat")
        return

    inter.storable = true
    inter.sprite_path = "res://interactable_sprite.tscn"
    inter.icon_path = "res://Assets/blue_orb.png"
    return inter
