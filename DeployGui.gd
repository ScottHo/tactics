class_name DeployGui extends Node2D

var collectionPanel: CollectionPanel
var upgradePanel: UpgradePanel
var deployPanel: DeployPanel
var startMissionButton: Button
var abortMissionButton: Button
var enemyPanel: MissionEnemyPanel
var objectiveLabel: Label
var specialsLabel: Label
var mission: Mission


func _ready():
    collectionPanel = $CollectionContainer
    upgradePanel = $SelectedContainer
    deployPanel = $DeployContainer
    startMissionButton = $StartMission
    abortMissionButton = $AbortMission
    enemyPanel = $EnemyPanel
    objectiveLabel = $Control/Objectives
    specialsLabel = $Control/SpecialsLabel
    collectionPanel.entity_selected.connect(entity_selected)
    upgradePanel.deployed.connect(entity_deployed)
    deployPanel.entity_removed.connect(entity_removed_from_deploy)
    startMissionButton.pressed.connect(startMission)
    abortMissionButton.pressed.connect(abortMission)
    start()
    return

func start():
    mission = Globals.curent_mission    
    upgradePanel.skill_points_base = Globals.skill_points
    collectionPanel.start()
    upgradePanel.reset()
    deployPanel.start()
    enemyPanel.start(mission.boss)
    objectiveLabel.text = mission.description
    var t = ""
    for i in mission.specials:
        var s: Special = i 
        t += s.display_name
        t += "\n"
        t += s.description
        t += "\n\n"
    specialsLabel.text = t
    startMissionButton.disabled = true
    return

func entity_selected(ent: Entity):
    upgradePanel.start(ent)
    return

func entity_deployed(ent: Entity):
    startMissionButton.disabled = false
    collectionPanel.entity_deployed(ent)
    deployPanel.add_entity(ent)
    if deployPanel.is_full():
        upgradePanel.set_deploy_full(true)
    return

func entity_removed_from_deploy(ent: Entity):
    collectionPanel.entity_undeployed(ent)
    upgradePanel.set_deploy_full(false)
    if deployPanel.is_empty():
        startMissionButton.disabled = true
    return

func startMission():
    Globals.level_debug_mode = false
    var entities_to_deploy = []
    for ent in deployPanel._entities:
        if ent != null:
            entities_to_deploy.append(ent)
    Globals.entities_to_deploy = entities_to_deploy
    get_tree().change_scene_to_file("res://level.tscn")
    return

func abortMission():
    get_tree().change_scene_to_file("res://demo_main_menu.tscn")
    return
