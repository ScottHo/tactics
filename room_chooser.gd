extends Node2D

@onready var back_button : Button = $BackButton
@onready var title : Label = $Title
@onready var room_container : Node2D = $RoomContainer
@onready var room_info : DetailedRoomInfo = $RoomContainer/DetailedRoomInfo
@onready var goButton : Button = $RoomContainer/GoButton
@onready var cancelButton : Button = $RoomContainer/CancelButton
@onready var choose_container : Node2D = $ChooserContainer
@onready var botButton : Button = $ChooserContainer/Bottom
@onready var midButton : Button = $ChooserContainer/Middle
@onready var topButton : Button = $ChooserContainer/Top
@onready var recruitPanel : Node2D = $RoomContainer/Recruit1
@onready var recruitSprite : Sprite2D = $RoomContainer/Recruit1/Sprite
@onready var recruitName : Label = $RoomContainer/Recruit1/Name
@onready var recruitStatsPanel : MissionEnemyPanel = $RoomContainer/Recruit1/EnemyPanel
@onready var recruitPassiveName : Label = $RoomContainer/Recruit1/AbilitiesGrid/Passive/Name
@onready var recruitPassiveDesc : Label = $RoomContainer/Recruit1/AbilitiesGrid/Passive/Description
@onready var recruitSpecName : Label = $RoomContainer/Recruit1/AbilitiesGrid/Special/Name
@onready var recruitSpecDesc : Label = $RoomContainer/Recruit1/AbilitiesGrid/Special/Description
@onready var recruitUltName : Label = $RoomContainer/Recruit1/AbilitiesGrid/Ultimate/Name
@onready var recruitUltDesc : Label = $RoomContainer/Recruit1/AbilitiesGrid/Ultimate/Description

var missions: Array = []
var recruits: Array = []
var room_idx: int = 1

func _ready():
    var level = Globals.current_level
    var _floor = level % 4
    
    setup_nodes()
    setup_panels(level, _floor)
    return

func setup_nodes():
    Globals.current_recruit = -1
    goButton.pressed.connect(func():
        Globals.current_mission = missions[room_idx]
        Globals.current_recruit = recruits[room_idx]
        get_tree().change_scene_to_file("res://DeployGui.tscn"))
    cancelButton.pressed.connect(switch_to_chooser)
    back_button.pressed.connect(func():
        get_tree().change_scene_to_file("res://Headquarters.tscn"))
    botButton.pressed.connect(func():
        room_idx = 0
        switch_to_room())
    midButton.pressed.connect(func():
        room_idx = 1
        switch_to_room())
    topButton.pressed.connect(func():
        room_idx = 2
        switch_to_room())
    return

func switch_to_room():
    setup_recruit(recruits[room_idx])
    room_info.start(missions[room_idx])    
    room_container.visible = true
    choose_container.visible = false
    return

func switch_to_chooser():
    room_container.visible = false
    choose_container.visible = true
    return

func setup_panels(level: int, _floor):
    switch_to_chooser()
    title.text = Utils.floor_title(level, _floor)
    if [4,8,12,16,17].has(level):
        var m: Mission
        if level == 4:
            m = MissionFactory.foundry_1_final_boss()
        elif level == 8:
            m = MissionFactory.foundry_2_final_boss()
        elif level == 12:
            m = MissionFactory.foundry_3_final_boss()
        elif level == 16:
            m = MissionFactory.foundry_3_final_boss()
        elif level == 17:
            m = MissionFactory.foundry_3_final_boss()
        missions = [m,m,m]
        $TileMapBoss.visible = true
        $TileMapFloor.visible = false
        recruitPanel.visible = false        
        botButton.visible = false
        topButton.visible = false

    else:
        setup_floor(level, _floor)
        $TileMapBoss.visible = false
        $TileMapFloor.visible = true

func setup_floor(level: int, _floor):
    if Globals.missions_found:
        missions = Globals.mission_options
        recruits = Globals.recruit_options
        return
        
    recruits = [0,0,0]
    if level <= 4:
        missions = MissionFactory.foundry_1_floors(_floor)
    elif level <= 8:
        missions = MissionFactory.foundry_2_floors(_floor)
    elif level <= 12:
        missions = MissionFactory.foundry_3_floors(_floor)
    elif level <= 16:
        missions = MissionFactory.foundry_3_floors(_floor)

    var bots = EntityFactory.new_recruits()
    if len(bots) >= 1:
        # Fill all bots up so that if there is only 1 left to recruit all rooms can recruit
        recruits[0] = bots[0]
        recruits[1] = bots[0]
        recruits[2] = bots[0]
    if len(bots) >= 2:
        recruits[1] = bots[1]
        recruits[2] = bots[1]
    if len(bots) >= 3:
        recruits[2] = bots[2]
    
    Globals.missions_found = true
    Globals.mission_options = missions
    Globals.recruit_options = recruits
    return

func setup_recruit(bot: EntityFactory.Bot):
    var ent = EntityFactory.create_bot(bot)
    recruitName.text = ent.display_name
    recruitSprite.texture = load(ent.icon_path)
    recruitStatsPanel.start(ent)
    recruitPassiveName.text = ent.action1.display_name
    recruitPassiveDesc.text = ent.action1.description
    recruitSpecName.text = ent.action1.display_name
    recruitSpecDesc.text = ent.action1.description
    recruitUltName.text = ent.action2.display_name
    recruitUltDesc.text = ent.action2.description
    return
