class_name EntityInfoTab extends Node2D

var hpLabel: Label
var charSprite: Sprite2D
var moveLabel: Label
var damageLabel: Label
var energyLabel: Label
var threatLabel: Label
var background: Sprite2D

func update_nodes():
    if hpLabel == null:
        charSprite = $CharacterSprite
        hpLabel = $Stats/HpLabel        
        moveLabel = $Stats/MovementLabel
        damageLabel = $Stats/DamageLabel
        energyLabel = $Stats/EnergyLabel
        threatLabel = $Stats/ThreatLabel
        background = $Background
    return

func update_from_entity(entity: Entity, is_ally: bool):
    update_nodes()
    charSprite.texture = entity.sprite.texture_resource()
    charSprite.scale = entity.sprite.texture_scale()*1.3
    hpLabel.text = str(entity.health)
    moveLabel.text = str(entity.get_movement())
    damageLabel.text = str(entity.get_damage())
    if is_ally:
        energyLabel.text = str(entity.energy)
        threatLabel.text = str(entity.threat)
        background.texture = load("res://info_box.png")
    else:
        energyLabel.text = "-"
        threatLabel.text = "-"
        background.texture = load("res://info_box_enemy.png")
    _set_colors(entity, is_ally)
    return

func _set_colors(entity: Entity, isAlly: bool):
    if entity.health < entity.get_low_health_threshold():
        print("??")
        _set_color(hpLabel, Color.RED)
    elif entity.health == entity.max_health:
        _set_color(hpLabel, Color.CYAN)
    else:
        _set_color(hpLabel, Color.WHITE)
        
    if entity.movement > entity.get_movement():
        _set_color(moveLabel, Color.CYAN)
    elif entity.movement < entity.get_movement():
        _set_color(moveLabel, Color.RED)
    else:
        _set_color(moveLabel, Color.WHITE)
        
    if entity.damage > entity.get_damage():
        _set_color(damageLabel, Color.CYAN)
    elif entity.damage < entity.get_damage():
        _set_color(damageLabel, Color.RED)
    else:
        _set_color(damageLabel, Color.WHITE)

    if isAlly:
        if entity.energy <=  1:
            _set_color(energyLabel, Color.RED)
        elif entity.energy == 5:
            _set_color(energyLabel, Color.CYAN)
        else:
            _set_color(energyLabel, Color.WHITE)
        if entity.threat == 5:
            _set_color(threatLabel, Color.RED)
        else:
            _set_color(energyLabel, Color.WHITE)
    return

func _set_color(label: Label, color: Color):
    var s : LabelSettings = label.get_label_settings()
    if s == null:
        s = LabelSettings.new()
    s.font_color = color
    label.set_label_settings(s)
    return
