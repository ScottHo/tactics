class_name Headquarters extends Node2D

var collectionPanel: CollectionPanel
var checkpoints: Checkpoints
var enterFloorButton: Button
var floorLabel: Label
var backButton: Button
var rosterButton: Button
var abortButton: Button
var botIcon: Sprite2D
var botName: Label
var botPanel: MissionEnemyPanel
var passivePanel: PassivePanel
var specialPanel1: SpecialDescriptionPanel
var specialPanel2: SpecialDescriptionPanel

func _ready():
    collectionPanel = $Collections/CollectionContainer
    checkpoints = $Levels/Checkpoints
    enterFloorButton = $Levels/EnterFloorButton
    floorLabel = $Levels/FloorLabel
    rosterButton = $Levels/RosterButton    
    abortButton = $Levels/AbortButton
    backButton = $Collections/BackButton
    passivePanel = $Collections/PassivePanel
    specialPanel1 = $Collections/SpecialPanel1
    specialPanel2 = $Collections/SpecialPanel2
    botIcon = $Collections/BotIcon
    botName = $Collections/BotName
    botPanel = $Collections/EnemyPanel
    collectionPanel.entity_selected.connect(entity_selected)
    enterFloorButton.pressed.connect(go_to_room_select)
    abortButton.pressed.connect(back_to_menu)
    backButton.pressed.connect(func():
        $Collections.visible = false
        $Levels.visible = true)
    rosterButton.pressed.connect(func():
        $Collections.visible = true
        $Levels.visible = false)
    passivePanel.clear()
    specialPanel1.clear()
    specialPanel2.clear()

    start()
    return

func start():
    collectionPanel.start()
    var level = Globals.current_level
    var _floor = level % 7
    floorLabel.text = Utils.floor_title(level, _floor)
    return

func entity_selected(ent: Entity):
    passivePanel.set_passive(ent.passive)
    specialPanel1.set_action(ent.action1)
    specialPanel2.set_action(ent.action2)
    botIcon.texture = load(ent.icon_path)
    botName.text = ent.display_name
    botPanel.start(ent)
    return

func go_to_room_select():
    get_tree().change_scene_to_file("res://room_chooser.tscn")
    return

func back_to_menu():
    get_tree().change_scene_to_file("res://demo_main_menu.tscn")
    return
