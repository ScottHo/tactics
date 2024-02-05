class_name DeployGui extends Node2D

var collectionPanel: CollectionPanel
var upgradePanel: UpgradePanel
var deployPanel: DeployPanel
var startMissionButton: Button
var backButton: Button
var detailedRoomInfo: DetailedRoomInfo
var mission: Mission


func _ready():
    collectionPanel = $CollectionContainer
    upgradePanel = $SelectedContainer
    deployPanel = $DeployContainer
    startMissionButton = $StartMission
    backButton = $BackButton
    detailedRoomInfo = $DetailedRoomInfo
    $DialogBox.end()
    collectionPanel.entity_selected.connect(func(e):
        entity_selected(e, false))
    upgradePanel.deployed.connect(entity_deployed)
    upgradePanel.undeployed.connect(entity_removed_from_deploy)
    deployPanel.entity_selected.connect(func(e):
        entity_selected(e, true))
    startMissionButton.pressed.connect(startMission)
    backButton.pressed.connect(back_to_headquarters)
    start()
    return

func start():
    mission = Globals.current_mission    
    upgradePanel.skill_points_base = Globals.skill_points
    collectionPanel.start()
    upgradePanel.reset()
    deployPanel.start()
    detailedRoomInfo.start(mission)
    if deployPanel.is_empty():
        startMissionButton.disabled = true
    return

func entity_selected(ent: Entity, undeploy=true):
    upgradePanel.start(ent, undeploy)
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
    var bots_alive = min(len(Globals.bots_collected) - len(Globals.bots_dead), 6)
    if bots_alive > deployPanel.ents_deployed:
        var t = "Under Deployed"
        var d = "You can have a maximum of 6 bots for the mission. Continue anyways?"
        $DialogBox.start(t, d, start_mission_cont)
    else:
        start_mission_cont()
    return
    
func start_mission_cont():
    $DialogBox.end()
    Globals.level_debug_mode = false
    var entities_to_deploy = []
    for ent in deployPanel._entities:
        if ent != null:
            entities_to_deploy.append(ent)
    Globals.entities_to_deploy = entities_to_deploy
    get_tree().change_scene_to_file("res://level.tscn")
    return

func back_to_headquarters():
    get_tree().change_scene_to_file("res://room_chooser.tscn")
    return
