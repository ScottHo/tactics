class_name Character_common extends Control


func setLabel(s):
    $Label.text = s
    return

func setMaxHP(hp: int):
    $TextureProgressBar.max_value = hp
    return

func setHP(hp: int):
    $TextureProgressBar.value = hp
    return