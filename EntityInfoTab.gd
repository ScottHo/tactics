class_name EntityInfoTab extends Node2D

var hpLabel: Label
var charSprite: Sprite2D
var moveLabel: Label
var damageLabel: Label
var energyLabel: Label
var threatLabel: Label
var background: Sprite2D
var _entity: Entity
var _is_ally: bool

func _ready():
    var r : ReferenceRect = $ReferenceRect
    r.mouse_entered.connect(expand)
    r.mouse_exited.connect(unexpand)
    unexpand()
    return

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
    _entity = entity
    _is_ally = is_ally
    charSprite.texture = _entity.sprite.texture_resource()
    charSprite.scale = _entity.sprite.texture_scale()*1.2
    update()
    return

func update():
    hpLabel.text = str(_entity.health)
    moveLabel.text = str(_entity.get_movement())
    damageLabel.text = str(_entity.get_damage())
    if _is_ally:
        energyLabel.text = str(_entity.energy)
        threatLabel.text = str(_entity.threat)
    else:
        energyLabel.text = "-"
        threatLabel.text = "-"
    $HealthBar.max_value = _entity.max_health
    $HealthBar.value = _entity.health
    _set_colors()
    return

func expand():
    $Stats.visible = true
    $Buffs1.visible = true
    $Buffs2.visible = true
    if _is_ally:
        background.texture = load("res://Assets/info_box_expanded.png")
    else:
        background.texture = load("res://Assets/info_box_enemy_expanded.png")
    return

func unexpand():
    $Stats.visible = false
    $Buffs1.visible = false
    $Buffs2.visible = false
    background.texture = load("res://Assets/info_box.png")
    return

func _set_colors():
    if _entity.health < _entity.get_low_health_threshold():
        _set_color(hpLabel, Color.RED)
    elif _entity.health == _entity.max_health:
        _set_color(hpLabel, Color.CYAN)
    else:
        _set_color(hpLabel, Color.WHITE)
        
    if _entity.movement > _entity.get_movement():
        _set_color(moveLabel, Color.CYAN)
    elif _entity.movement < _entity.get_movement():
        _set_color(moveLabel, Color.RED)
    else:
        _set_color(moveLabel, Color.WHITE)
        
    if _entity.damage > _entity.get_damage():
        _set_color(damageLabel, Color.CYAN)
    elif _entity.damage < _entity.get_damage():
        _set_color(damageLabel, Color.RED)
    else:
        _set_color(damageLabel, Color.WHITE)

    if _is_ally:
        if _entity.energy <=  1:
            _set_color(energyLabel, Color.RED)
        elif _entity.energy == 5:
            _set_color(energyLabel, Color.CYAN)
        else:
            _set_color(energyLabel, Color.WHITE)
        if _entity.threat == 5:
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
