class_name SpecialDescriptionPanel extends Node2D

@onready var descName: Label = $DescriptionName
@onready var descMain: Label = $DescriptionLabel
@onready var costLabel: Label = $CostLabel
@onready var affectsLabel: Label = $AffectsLabel
@onready var grid: GridContainer = $GridContainer

func name_label(c) -> Label:
    return c.get_child(0)

func stat1_label(c) -> Label:
    return c.get_child(1)

func extra_stats(c) -> Control:
    return c.get_child(2)

func slash1_label(c) -> Label:
    return extra_stats(c).get_child(0)

func stat2_label(c) -> Label:
    return extra_stats(c).get_child(1)

func slash2_label(c) -> Label:
    return extra_stats(c).get_child(2)
    
func stat3_label(c) -> Label:
    return extra_stats(c).get_child(3)

func slash3_label(c) -> Label:
    return extra_stats(c).get_child(4)
    
func stat4_label(c) -> Label:
    return extra_stats(c).get_child(5)

func container(idx: int) -> Control:
    return grid.get_child(idx)
    
func set_action(action: Action):
    descName.text = action.display_name
    descMain.text = action.description
    costLabel.text = str(action.cost())
    affectsLabel.text = action.get_from_stats("Affects", "")
    parse_stats(action)
    return

func clear():
    for c in grid.get_children():
        c.visible = false
    descName.text = "-"
    descMain.text = "-"
    costLabel.text = "-"
    affectsLabel.text = "-"
    return

func parse_stats(action: Action):
    var index = grid.get_child_count() - 1
    var stats: Dictionary = action.stats
    for c in grid.get_children():
        c.visible = false
    for key in stats.keys():
        if key == "Cost" or key == "Affects":
            continue
        var c = container(index)
        name_label(c).text = key
        if stats[key] is Array:
            parse_multi_stat(c, key, stats[key], action.level)
        else:
            parse_single_stat(c, key, stats[key])
        c.visible = true
        index -= 1
        if index == -1:
            return
    return

func parse_multi_stat(c, key, _stat, level):
    var stat1: Label = stat1_label(c)
    var slash1: Label = slash1_label(c)
    var stat2: Label = stat2_label(c)
    var slash2: Label = slash2_label(c)
    var stat3: Label = stat3_label(c)
    var slash3: Label = slash3_label(c)
    var stat4: Label = stat4_label(c)
    # Show the extra stats container
    extra_stats(c).visible = true
    
    # Format stats 1
    stat1.text = format_single_stat(key, _stat[0])
    modulate_label(stat1, level, 1)
    stat1.reset_size()
    
    slash1.position.x = stat1.position.x + stat1.size.x + 3
    stat2.position.x = slash1.position.x + slash1.size.x + 3
    stat2.text = format_single_stat(key, _stat[1])
    modulate_label(stat2, level, 2)
    stat2.reset_size()
    
    slash2.position.x = stat2.position.x + stat2.size.x + 3
    stat3.position.x = slash2.position.x + slash2.size.x + 3
    stat3.text = format_single_stat(key, _stat[2])
    modulate_label(stat3, level, 3)
    stat3.reset_size()
        
    slash3.position.x = stat3.position.x + stat3.size.x + 3
    stat4.position.x = slash3.position.x + slash3.size.x + 3
    stat4.text = format_single_stat(key, _stat[3])
    modulate_label(stat4, level, 4)
    stat4.reset_size()
    return

func modulate_label(label: Label, level: int, target_level: int):
    if level == target_level:
        label.add_theme_color_override("font_color", Color.WHITE)
        label.add_theme_constant_override("outline_size", 1)
    else:
        label.add_theme_color_override("font_color", Color("8e8e8e"))
        label.add_theme_constant_override("outline_size", 0)
    return

func parse_single_stat(c, key, _stat):
    stat1_label(c).text = format_single_stat(key, _stat)
    extra_stats(c).visible = false
    return

func format_single_stat(key, s):
    return key_prefix(key) + str(s) + key_suffix(key) 

func key_prefix(k) -> String:
    return ""

func key_suffix(k) -> String:
    if k in ["Damage Amp"]:
        return "x"
    return ""
