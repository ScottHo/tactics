class_name EntityInfoTab extends Node2D


func update_from_entity(entity: Entity, is_ally: bool):
    $CharacterSprite.texture = entity.sprite.texture_resource()
    $CharacterSprite.scale = entity.sprite.texture_scale()*1.3
    $Stats/HpLabel.text = str(entity.health)
    $Stats/MovementLabel.text = str(entity.movement - entity.movement_penalty)
    $Stats/DamageLabel.text = str(entity.damage)
    if is_ally:
        if entity.health < 4:
            $Stats/HpLabel
        $Stats/EnergyLabel.text = str(entity.energy)
        $Stats/ThreatLabel.text = str(entity.threat)
        $Background.texture = load("res://info_box.png")
    else:
        $Stats/EnergyLabel.text = "-"
        $Stats/ThreatLabel.text = "-"
        $Background.texture = load("res://info_box_enemy.png")
    return
