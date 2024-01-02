class_name StatPanel extends Node2D

# Called when the node enters the scene tree for the first time.
func show_initiative():
    $Name.text = "Initiative"
    $Description.text = "Increases the frequency of turns taken"
    return

func show_range():
    $Name.text = "Range"
    $Description.text = "Base range for attacks and specials"
    return

func show_damage():
    $Name.text = "Damage"
    $Description.text = "Base damage for attacks and specials"
    return

func show_movement():
    $Name.text = "Movement"
    $Description.text = "Number of moves available for repositioning. Can be used before and/or after other actions"
    return

func show_health():
    $Name.text = "Health"
    $Description.text = "The starting and max health"
    return

func show_armor():
    $Name.text = "Armor"
    $Description.text = "Decreases the amount of damage taken per instance of damage for each point of armor"
    return

