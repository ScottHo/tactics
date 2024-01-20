class_name PassivePanel extends Node2D

func set_passive(p: Passive):
    $DescriptionName.text = p.display_name
    $DescriptionLabel.text = p.description
    return
