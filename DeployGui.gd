class_name DeployGui extends Node2D

var collectionPanel: CollectionPanel
var upgradePanel: UpgradePanel
var deployPanel: DeployPanel
var startMissionButton: Button
var enemyPanel: MissionEnemyPanel
var objectiveLabel: Label
var mission: Mission


func _ready():
    collectionPanel = $CollectionContainer
    upgradePanel = $SelectedContainer
    deployPanel = $DeployContainer
    startMissionButton = $StartMission
    enemyPanel = $EnemyPanel
    objectiveLabel = $Control/Objectives
    collectionPanel.entity_selected.connect(entity_selected)
    upgradePanel.deployed.connect(entity_deployed)
    deployPanel.entity_removed.connect(entity_removed_from_deploy)
    startMissionButton.pressed.connect(startMission)
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
        collectionPanel.deploy_full = true
    return

func entity_removed_from_deploy(ent: Entity):
    collectionPanel.entity_undeployed(ent)
    collectionPanel.deploy_full = false
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