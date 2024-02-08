class_name EntityInfoTab extends Node2D

var healthBar: TextureProgressBar
var energyBar: TextureProgressBar
var healthLabel: Label
var slashLabel: Label
var maxHealthLabel: Label
var moveLabel: Label
var damageLabel: Label
var rangeLabel: Label
var initiativeLabel: Label
var armorLabel: Label
var threatLabel: Label
var background: Sprite2D
var _entity: Entity


func _ready():
    #var r : ReferenceRect = $ReferenceRect
    #r.mouse_entered.connect(expand)
    #r.mouse_exited.connect(unexpand)
    return

func update_nodes():
    if moveLabel == null:
        healthBar = $HealthBar
        energyBar = $EnergyBar
        healthLabel = $HealthBar/HealthLabel
        slashLabel = $HealthBar/SlashLabel
        maxHealthLabel = $HealthBar/MaxHealthLabel
        moveLabel = $Stats/Control/MoveLabel
        initiativeLabel = $Stats/Control2/InitiativeLabel        
        damageLabel = $Stats/Control3/DamageLabel
        rangeLabel = $Stats/Control4/RangeLabel
        armorLabel = $Stats/Control5/ArmorLabel
        threatLabel = $Stats/Control6/ThreatLabel
        background = $Background
    return

func update_from_entity(entity: Entity):
    update_nodes()
    unexpand()
    _entity = entity
    update()
    return

func update():
    healthLabel.text = str(_entity.health)
    maxHealthLabel.text = str(_entity.get_max_health())
    
    moveLabel.text = str(_entity.get_movement())
    damageLabel.text = str(_entity.get_damage())    
    rangeLabel.text = str(_entity.get_range())
    initiativeLabel.text = str(_entity.get_initiative())
    armorLabel.text = str(_entity.get_armor())
    if _entity.is_ally:
        threatLabel.text = str(_entity.threat)
        background.texture = load("res://Assets/GUI/info_box_hover.png")
    else:
        background.texture = load("res://Assets/GUI/info_box_enemy_hover.png")
        threatLabel.text = "-"
        healthBar.texture_progress = load("res://Assets/GUI/Health_Over_Thick_Red.png")
    healthBar.max_value = _entity.get_max_health()
    healthBar.value = _entity.health
    energyBar.value = _entity.energy
    if _entity.passive != null:
        if _entity.passive.is_aura:
            $Passive/ShortName.text = _entity.passive.aura_short_desc
    _set_colors()
    return

func expand():
    background.visible = true
    healthBar.visible = true
    $Stats.visible = true
    if _entity.passive != null:
        if _entity.passive.is_aura:
            $Passive.visible = true
    if _entity.is_ally:
        energyBar.visible = true
    return

func unexpand():
    background.visible = false
    healthBar.visible = false
    $Stats.visible = false
    energyBar.visible = false
    $Passive.visible = false
    return

func _set_colors():
    Utils.set_label_color(healthLabel, Utils.health_color(_entity))
    Utils.set_label_color(moveLabel, Utils.movement_color(_entity))
    Utils.set_label_color(damageLabel, Utils.damage_color(_entity))
    Utils.set_label_color(rangeLabel, Utils.range_color(_entity))
    Utils.set_label_color(initiativeLabel, Utils.initiative_color(_entity))
    Utils.set_label_color(armorLabel, Utils.armor_color(_entity))
    Utils.set_label_color(threatLabel, Utils.threat_color(_entity))
    return
