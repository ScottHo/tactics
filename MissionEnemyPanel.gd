class_name MissionEnemyPanel extends Control

@onready var maxHealthLabel = $GridContainer/Health/Label
@onready var moveLabel = $GridContainer/Movement/Label
@onready var initiativeLabel = $GridContainer/Initiative/Label
@onready var damageLabel = $GridContainer/Damage/Label
@onready var rangeLabel = $GridContainer/Range/Label
@onready var armorLabel = $GridContainer/Armor/Label
var _entity

func _ready():
    return

func clear():
    maxHealthLabel.text = "-"
    moveLabel.text = "-"
    damageLabel.text = "-"
    rangeLabel.text = "-"
    initiativeLabel.text = "-"
    armorLabel.text = "-"
    return

func start(e: Entity):
    _entity = e
    maxHealthLabel.text = str(_entity.get_max_health())
    moveLabel.text = str(_entity.get_movement())
    damageLabel.text = str(_entity.get_damage())    
    rangeLabel.text = str(_entity.get_range())
    initiativeLabel.text = str(_entity.get_initiative())
    armorLabel.text = str(_entity.get_armor())
    return
