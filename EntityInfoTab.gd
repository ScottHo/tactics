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
    moveLabel.text = str(entity.movement - entity.movement_penalty)
    damageLabel.text = str(entity.damage)
    if is_ally:
        energyLabel.text = str(entity.energy)
        threatLabel.text = str(entity.threat)
        background.texture = load("res://info_box.png")
    else:
        _set_colors(entity, is_ally)
        energyLabel.text = "-"
        threatLabel.text = "-"
        background.texture = load("res://info_box_enemy.png")
    return

func _set_colors(entity: Entity, isAlly: bool):
    if isAlly:
        if entity.health < 4:
            _set_color(hpLabel, Color.RED)
        if entity.health == entity.max_health:
            _set_color(hpLabel, Color.CYAN)
        if entity.movement > 5:
            _set_color(moveLabel, Color.CYAN)
        if entity.movement_penalty >=  1:
            _set_color(moveLabel, Color.RED)
        if entity.damage > 2:
            _set_color(damageLabel, Color.CYAN)
        if entity.damage < 2:
            _set_color(damageLabel, Color.RED)
    else:
        if entity.health < 10:
            _set_color(hpLabel, Color.RED)
        if entity.energy <=  1:
            _set_color(energyLabel, Color.RED)
        if entity.energy == 5:
            _set_color(energyLabel, Color.CYAN)
        if entity.threat == 5:
            _set_color(threatLabel, Color.RED)
    return

func _set_color(label: Label, color: Color):
    var s : LabelSettings = label.get_label_settings()
    if s == null:
        s = LabelSettings.new()
    s.font_color = Color.RED
    label.set_label_settings(s)
    return
