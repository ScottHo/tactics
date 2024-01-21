class_name PassivePanel extends Node2D

func set_passive(p: Passive):
    if p != null:
        $DescriptionName.text = p.display_name
        $DescriptionLabel.text = p.description
    return

func clear():
    $DescriptionName.text = "None"
    $DescriptionLabel.text = ""
    return
