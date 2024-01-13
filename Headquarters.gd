class_name Headquarters extends Node2D

var collectionPanel: CollectionPanel
var checkpoints: Checkpoints
var enterFloorButton: Button
var floorLabel: Label
var backButton: Button
var botIcon: Sprite2D
var botPanel: MissionEnemyPanel
var specialPanel1: SpecialDescriptionPanel
var specialPanel2: SpecialDescriptionPanel


func _ready():
    collectionPanel = $CollectionContainer
    checkpoints = $Checkpoints
    enterFloorButton = $EnterFloorButton
    floorLabel = $FloorLabel    
    backButton = $BackButton
    specialPanel1 = $SpecialPanel
    specialPanel2 = $SpecialPanel2
    botIcon = $BotIcon
    botPanel = $EnemyPanel
    collectionPanel.entity_selected.connect(entity_selected)
    enterFloorButton.pressed.connect(go_to_room_select)
    backButton.pressed.connect(back_to_menu)
    
    specialPanel1.clear()
    specialPanel2.clear()

    start()
    return

func start():
    collectionPanel.start()
    var level = Globals.current_level
    var floor = level % 4
    floorLabel.text = Utils.floor_title(level, floor)
    return

func entity_selected(ent: Entity):
    specialPanel1.set_action(ent.action1)
    specialPanel2.set_action(ent.action2)
    botIcon.texture = load(ent.icon_path)
    botPanel.start(ent)
    return

func go_to_room_select():
    get_tree().change_scene_to_file("res://room_chooser.tscn")
    return

func back_to_menu():
    get_tree().change_scene_to_file("res://demo_main_menu.tscn")
    return
