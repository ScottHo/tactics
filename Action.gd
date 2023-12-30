class_name Action extends Node

var shape: Array
var effect: Callable
var display_name: String
var description: String
var stats: Dictionary
var level := 1

func get_from_stats(key, default=0):
    if stats.has(key):
        if stats[key] is Array:
            return stats[key][level-1]
        return stats[key]
    return default

func range_modifier():
    return get_from_stats("Range Modifier")

func self_cast_only():
    if get_from_stats("Affects", "All Units") == "Self":
        return true
    return false

func cost():
    return get_from_stats("Cost")

func self_castable():
    var a = affects()
    return a == "Self" or a == "All Friendly Units" or a == "All Units"

func affects():
    return get_from_stats("Affects", "All Units")

func stats_to_string() -> String:
    var ret = ""
    for k in stats.keys():
        ret += k
        ret += ": "
        ret += key_suffix(k)
        ret += str(get_from_stats(k))
        ret += "\n"
    return ret

func key_suffix(k) -> String:
    if k in ["Range Modifier", "Damage Modifier"]:
        return "+"
    return ""
        
        
