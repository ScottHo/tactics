class_name MissionGui extends Node2D

@onready var enemyPanel: MissionEnemyPanel = $EnemyPanel
@onready var bossDescription: Label = $BossDescription
@onready var missionDescription: Label = $MissionDescription
@onready var specialsGrid: GridContainer = $BossSpecials
@onready var environmentPanel: MissionEnvironmentPanel = $EnvironmentPanel
@onready var cancelButton: Button = $Buttons/CancelButton
@onready var okButton: Button = $Buttons/OkButton

var _mission: Mission

func _ready():
    okButton.pressed.connect(ok_button_pressed)
    cancelButton.pressed.connect(cancel_button_pressed)
    start()
    return

func start():
    environmentPanel.start()
    clear_specials()
    
    var mission: Mission = MissionFactory.mission_1()
    setup_mission(mission)
    return

func setup_mission(mission: Mission):
    _mission = mission
    enemyPanel.start(mission.boss)
    bossDescription.text = mission.boss.description
    missionDescription.text = mission.description
    for i in range(len(mission.specials)):
        var c = container(i)
        c.visible = true
        specialName(c).text = mission.specials[i].display_name
        specialDescription(c).text = mission.specials[i].description
    for i in range(len(mission.buffs)):
        environmentPanel.set_buff(mission.buffs[i], i)
    return

func clear_specials():
    for c in specialsGrid.get_children():
        c.visible = false
    return

func specialName(c) -> Label:
    return c.get_child(0)

func specialDescription(c) -> Label:
    return c.get_child(1)

func container(idx: int) -> Control:
    return specialsGrid.get_child(idx)

func ok_button_pressed():
    Globals.curent_mission = _mission
    get_tree().change_scene_to_file("res://DeployGui.tscn")
    return

func cancel_button_pressed():
    Globals.curent_mission = null
    return
