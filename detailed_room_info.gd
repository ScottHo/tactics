class_name DetailedRoomInfo extends Node2D


func _ready():
    for c in $SpecialsGrid.get_children():
        for _c in c.get_children():
            _c.text = ""
    return
    
func start(mission: Mission):
    $BossSprite.texture = load(mission.boss.icon_path)
    $BossName.text = "Boss: " + mission.boss.display_name
    $EnemyPanel.start(mission.boss)
    $SpecialsPerTurn.text = str(mission.specials_per_turn)
    for i in range(len(mission.specials)):
        var s: Special = mission.specials[i]
        $SpecialsGrid.get_child(i).get_child(0).text = s.display_name.capitalize() + " - " + s.description
    for i in range(len(mission.extra_objectives)):
        var o: Objective = mission.extra_objectives[i]
        $SpecialsGrid.get_child(i+1).get_child(0).text = "Optional - %s" % o.description 
    return
