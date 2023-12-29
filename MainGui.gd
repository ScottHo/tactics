class_name MainGui extends Node2D

var collectionPanel: CollectionPanel
var upgradePanel: UpgradePanel
var deployPanel: DeployPanel


func _ready():
    collectionPanel = $CollectionContainer
    upgradePanel = $SelectedContainer
    deployPanel = $DeployContainer
    collectionPanel.entity_selected.connect(entity_selected)
    upgradePanel.deployed.connect(entity_deployed)
    start()
    return

func start():
    collectionPanel.populate_entities()
    return

func entity_selected(ent: Entity):
    upgradePanel.set_entity(ent)
    print("?")
    return

func entity_deployed(ent: Entity):
    return

