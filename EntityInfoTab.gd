class_name EntityInfoTab extends Node2D

var healthBar: TextureProgressBar
var energyBar: TextureProgressBar
var healthLabel: Label
var slashLabel: Label
var maxHealthLabel: Label
var moveLabel: Label
var damageLabel: Label
var rangeLabel: Label
var speedLabel: Label
var armorLabel: Label
var threatLabel: Label
var background: Sprite2D
var _entity: Entity


func _ready():
    var r : ReferenceRect = $ReferenceRect
    r.mouse_entered.connect(expand)
    r.mouse_exited.connect(unexpand)
    return

func update_nodes():
    if moveLabel == null:
        healthBar = $HealthBar
        energyBar = $EnergyBar
        healthLabel = $HealthBar/HealthLabel
        slashLabel = $HealthBar/SlashLabel
        maxHealthLabel = $HealthBar/MaxHealthLabel
        moveLabel = $Stats/Control/MoveLabel
        speedLabel = $Stats/Control2/SpeedLabel        
        damageLabel = $Stats/Control3/DamageLabel
        rangeLabel = $Stats/Control4/RangeLabel
        armorLabel = $Stats/Control5/ArmorLabel
        threatLabel = $Stats/Control6/ThreatLabel
        background = $Background
    return

func update_from_entity(entity: Entity):
    update_nodes()
    _entity = entity
    update()
    return

func update():
    healthLabel.text = str(_entity.health)
    healthLabel.reset_size()
    var healthLabel_x = healthLabel.size.x
    maxHealthLabel.position = healthLabel.position + Vector2(healthLabel_x+15, 0)
    slashLabel.position = healthLabel.position + Vector2(healthLabel_x, 0)
    maxHealthLabel.text = str(_entity.max_health)
    
    moveLabel.text = str(_entity.get_movement())
    damageLabel.text = str(_entity.get_damage())    
    rangeLabel.text = str(_entity.get_range())
    speedLabel.text = str(_entity.get_speed())
    armorLabel.text = str(_entity.get_armor())
    if _entity.is_ally:
        threatLabel.text = str(_entity.threat)
        background.texture = load("res://Assets/info_box_hover.png")
    else:
        background.texture = load("res://Assets/info_box_enemy_hover.png")
        threatLabel.text = "-"
    healthBar.max_value = _entity.max_health
    healthBar.value = _entity.health
    energyBar.value = _entity.energy    
    _set_colors()
    return

func expand():
    background.visible = true
    healthBar.visible = true
    $Stats.visible = true
    if _entity.is_ally:
        energyBar.visible = true
    return

func unexpand():
    background.visible = false
    healthBar.visible = false
    $Stats.visible = false
    energyBar.visible = false
    return

func _set_colors():
    Utils.set_label_color(healthLabel, Utils.health_color(_entity))
    Utils.set_label_color(moveLabel, Utils.movement_color(_entity))
    Utils.set_label_color(damageLabel, Utils.damage_color(_entity))
    Utils.set_label_color(rangeLabel, Utils.range_color(_entity))
    Utils.set_label_color(speedLabel, Utils.speed_color(_entity))
    Utils.set_label_color(armorLabel, Utils.armor_color(_entity))
    Utils.set_label_color(threatLabel, Utils.threat_color(_entity))
    return
