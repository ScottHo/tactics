class_name ScoreService extends Node2D

var turnsTaken := 0
var _state: State

func _ready():
    $OkButton.pressed.connect(return_to_menu)
    return

func setState(state: State):
    _state = state
    return

func turn_taken():
    turnsTaken += 1
    return

func show_score(win: bool):
    $GridContainer/TurnsTaken.text = str(turnsTaken)
    $"GridContainer/Boss Health".text = str(_state.get_entity(_state.enemies[0]).health)
    $GridContainer/NumDead.text = str(len(_state.allies) - len(_state.all_allies_alive()))
    $"GridContainer/Bot Name".text = _state.get_entity(_state.allies[0]).display_name
    $GridContainer/Damage.text = str(_state.get_entity(_state.allies[0]).damage_done)
    if len(_state.allies) > 1:
        $"GridContainer/Bot Name2".text = _state.get_entity(_state.allies[1]).display_name
        $GridContainer/Damage2.text = str(_state.get_entity(_state.allies[1]).damage_done)
    if len(_state.allies) > 2:
        $"GridContainer/Bot Name3".text = _state.get_entity(_state.allies[2]).display_name
        $GridContainer/Damage3.text = str(_state.get_entity(_state.allies[2]).damage_done)
    if len(_state.allies) > 3:
        $"GridContainer/Bot Name4".text = _state.get_entity(_state.allies[3]).display_name
        $GridContainer/Damage4.text = str(_state.get_entity(_state.allies[3]).damage_done)
    if len(_state.allies) > 4:
        $"GridContainer/Bot Name5".text = _state.get_entity(_state.allies[4]).display_name
        $GridContainer/Damage5.text = str(_state.get_entity(_state.allies[4]).damage_done)
    if len(_state.allies) > 5:
        $"GridContainer/Bot Name6".text = _state.get_entity(_state.allies[5]).display_name
        $GridContainer/Damage6.text = str(_state.get_entity(_state.allies[5]).damage_done)
    $GridContainer/SkillPointsEarned.text = str(calc_points(win))
    visible = true
    return

func return_to_menu():
    $Timer.timeout.connect(func():
        if Globals.current_level >= 8:
            $DialogBox.start("Demo Complete", "\
Thanks for playing! Have feedback? Want updates? Follow @scuffed_keys on X/Twitter!

Steam Page coming soon.",
            func():
                get_tree().change_scene_to_file("res://demo_main_menu.tscn"),
                false)
                
        else:
            get_tree().change_scene_to_file("res://Menus/Headquarters.tscn")
        )
    $Timer.start(2)
    $Fader.visible = true
    var tween = get_tree().create_tween()
    tween.tween_property($Fader, "color:a", 1, 2)
    return

func calc_points(win) -> int:
    if Globals.current_mission.is_tutorial:
        return 0    
    if win:
        return 2
    return 0
