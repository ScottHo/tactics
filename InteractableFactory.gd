class_name InteractableFactory

static func create_blue_orb_thing() -> Interactable:
    var inter = Interactable.new()
    inter.display_name = "Blue Orb Buff Thing"
    inter.description = "Pick up for +3 damage, but -3 movement"
    inter.effect = func (user: Entity):
        user.update_damage(3)
        user.update_movement(-3)
        return

    inter.drop_effect = func (user: Entity):
        user.update_damage(-3)
        user.update_movement(3)
        return

    inter.repeated_effect = func (user: Entity):
        print("Interactable repeated effect")
        return

    inter.storable = true
    inter.sprite_path = "res://interactable_sprite.tscn"
    inter.icon_path = "res://Assets/blue_orb.png"
    return inter
