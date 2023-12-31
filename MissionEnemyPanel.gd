class_name MissionEnemyPanel extends Control

@onready var maxHealthLabel = $GridContainer/Health/Label
@onready var moveLabel = $GridContainer/Movement/Label
@onready var speedLabel = $GridContainer/Speed/Label
@onready var damageLabel = $GridContainer/Damage/Label
@onready var rangeLabel = $GridContainer/Range/Label
@onready var armorLabel = $GridContainer/Armor/Label
@onready var bossSprite = $BossSprite
@onready var bossName = $BossName
var _entity

func _ready():
    return

func clear():
    maxHealthLabel.text = "-"
    moveLabel.text = "-"
    damageLabel.text = "-"
    rangeLabel.text = "-"
    speedLabel.text = "-"
    armorLabel.text = "-"
    bossSprite.texture = load(Globals.NO_BOT_ICON_PATH)
    bossName.text = "-"
    return

func start(e: Entity):
    _entity = e
    maxHealthLabel.text = str(_entity.get_max_health())
    moveLabel.text = str(_entity.get_movement())
    damageLabel.text = str(_entity.get_damage())    
    rangeLabel.text = str(_entity.get_range())
    speedLabel.text = str(_entity.get_speed())
    armorLabel.text = str(_entity.get_armor())
    bossSprite.texture = load(_entity.icon_path)
    bossName.text = _entity.display_name
    return
