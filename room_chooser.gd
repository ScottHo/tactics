extends Node2D

var back_button: Button
var room_info1: DetailedRoomInfo
var room_info2: DetailedRoomInfo
var room_info3: DetailedRoomInfo
var recruit_1: Node2D
var recruit_2: Node2D
var recruit_3: Node2D
var entity_1: Entity
var entity_2: Entity
var entity_3: Entity
var title: Label
var mission1: Mission
var mission2: Mission
var mission3: Mission
var e_recruit_bot_1: EntityFactory.Bot
var e_recruit_bot_2: EntityFactory.Bot
var e_recruit_bot_3: EntityFactory.Bot


func button(container) -> Button:
    return container.get_child(0)

func sprite(container) -> Sprite2D:
    return container.get_child(1)

func label(container) -> Label:
    return container.get_child(3)

func _ready():
    var level = Globals.current_level
    var floor = level % 4
    
    setup_nodes()
    setup_panels(level, floor)
    return

func setup_nodes():
    back_button = $BackButton    
    room_info1 = $DetailedRoomInfo
    room_info2 = $DetailedRoomInfo2
    room_info3 = $DetailedRoomInfo3
    recruit_1 = $Recruit1
    recruit_2 = $Recruit2
    recruit_3 = $Recruit3
    title = $Title
    room_info1.visible = true
    room_info2.visible = true
    room_info3.visible = true
    recruit_1.visible = true
    recruit_2.visible = true
    recruit_3.visible = true
    Globals.current_recruit = -1
    button(recruit_1).pressed.connect(func():
        Globals.current_mission = mission1
        Globals.current_recruit = e_recruit_bot_1
        get_tree().change_scene_to_file("res://DeployGui.tscn"))
    button(recruit_2).pressed.connect(func():
        Globals.current_mission = mission2
        Globals.current_recruit = e_recruit_bot_2
        get_tree().change_scene_to_file("res://DeployGui.tscn"))
    button(recruit_3).pressed.connect(func():
        Globals.current_mission = mission3
        Globals.current_recruit = e_recruit_bot_3
        get_tree().change_scene_to_file("res://DeployGui.tscn"))
    back_button.pressed.connect(func():
        get_tree().change_scene_to_file("res://Headquarters.tscn"))
    return

func setup_panels(level: int, floor):
    title.text = Utils.floor_title(level, floor)
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
        setup_foundry_boss_panels()
        room_info2.start(m, "FOUNDRY BOSS")
        mission2 = m

    else:
        setup_floor(level, floor)

func setup_foundry_boss_panels():
    recruit_1.visible = false
    room_info1.visible = false
    recruit_3.visible = false
    room_info3.visible = false
    label(recruit_2).text = "None"
    sprite(recruit_2).texture = load(Globals.NO_BOT_ICON_PATH)
    return

func setup_floor(level: int, floor):
    if Globals.missions_found:
        mission1 = Globals.mission_options[0]
        mission2 = Globals.mission_options[1]
        mission3 = Globals.mission_options[2]
        e_recruit_bot_1 = Globals.recruit_options[0]
        e_recruit_bot_2 = Globals.recruit_options[1]
        e_recruit_bot_3 = Globals.recruit_options[2]
        
        setup_floor_missions()
        setup_floor_recruits()
        return
        
    var missions = []
    if level <= 4:
        missions = MissionFactory.foundry_1_floors(floor)
    elif level <= 8:
        missions = MissionFactory.foundry_2_floors(floor)
    elif level <= 12:
        missions = MissionFactory.foundry_3_floors(floor)
    elif level <= 16:
        missions = MissionFactory.foundry_3_floors(floor)

    var bots = EntityFactory.new_recruits()
    if len(bots) >= 1:
        # Fill all bots up so that if there is only 1 left to recruit all rooms can recruit
        e_recruit_bot_1 = bots[0]
        e_recruit_bot_2 = bots[0]
        e_recruit_bot_3 = bots[0]
    if len(bots) >= 2:
        e_recruit_bot_2 = bots[1]
        e_recruit_bot_3 = bots[1]
    if len(bots) >= 3:
        e_recruit_bot_3 = bots[2]
    
    mission1 = missions[0]
    mission2 = missions[1]
    mission3 = missions[2]

    setup_floor_missions()
    setup_floor_recruits()
    
    Globals.missions_found = true
    Globals.mission_options = missions
    Globals.recruit_options = [e_recruit_bot_1, e_recruit_bot_2, e_recruit_bot_3] 
    return
    
func setup_floor_missions():
    room_info1.start(mission1, "ROOM A")
    room_info2.start(mission2, "ROOM B")
    room_info3.start(mission3, "ROOM C")
    return

func setup_floor_recruits():
    setup_recruit(recruit_1, e_recruit_bot_1)
    setup_recruit(recruit_2, e_recruit_bot_2)
    setup_recruit(recruit_3, e_recruit_bot_3)
    return

func setup_recruit(container: Node2D, bot: EntityFactory.Bot):
    var ent = EntityFactory.create_bot(bot)
    label(container).text = ent.display_name
    sprite(container).texture = load(ent.icon_path)
    return
