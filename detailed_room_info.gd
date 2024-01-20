class_name DetailedRoomInfo extends Node2D


func _ready():
    for c in $SpecialsGrid.get_children():
        for _c in c.get_children():
            _c.text = ""
    return
    
func start(mission: Mission):
    $BossSprite.texture = load(mission.boss.icon_path)
    $BossName.text = mission.boss.display_name
    $EnemyPanel.start(mission.boss)
    $SpecialsPerTurn.text = str(mission.specials_per_turn)
    for i in range(len(mission.specials)):
        var s: Special = mission.specials[i]
        $SpecialsGrid.get_child(i).get_child(0).text = s.display_name
        $SpecialsGrid.get_child(i).get_child(1).text = s.description
    return
