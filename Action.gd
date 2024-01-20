class_name Action extends Node

var shape: Array
var effect: Callable
var display_name: String
var description: String
var stats: Dictionary
var level := 1
var animation_path : String = ""
var is_ultimate := false

func get_from_stats(key, default=0):
    if stats.has(key):
        if stats[key] is Array:
            return stats[key][level-1]
        return stats[key]
    return default

func range_modifier() -> int:
    return get_from_stats("Extra Range")

func threat() -> int:
    return get_from_stats("Threat Gain", 0)

func self_cast_only():
    if get_from_stats("Affects", "All Units") == "Self":
        return true
    return false

func cost():
    return get_from_stats("Cost")

func self_castable():
    var a = affects()
    return a == "Self" or a == "All Allied Units" or a == "All Units"

func affects():
    return get_from_stats("Affects", "All Units")

func clone() -> Action:
    var a = Action.new()
    a.shape = shape
    a.effect = effect
    a.display_name = display_name
    a.description = description
    a.stats = stats
    a.level = level
    return a
