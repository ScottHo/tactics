class_name PassivePanel extends Node2D

var has_data := false

func set_passive(p: Passive):
    if p != null:
        $DescriptionName.text = p.display_name
        $DescriptionLabel.text = p.description
        has_data = true
    else:
        has_data = false
    return

func clear():
    $DescriptionName.text = "None"
    $DescriptionLabel.text = ""
    has_data = false
    return
