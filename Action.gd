class_name Action extends Node

var shape: Array
var effect: Callable
var display_name: String
var description: String
var stats: Dictionary
var highlight_style: Vector2i = Highlights.ATTACK
var level := 1
var animation_path : String = ""
var type : int
var spawn

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
    if get_from_stats("Affects", TargetTypes.ANY) == TargetTypes.SELF:
        return true
    return false

func cost():
    return get_from_stats("Cost")

func self_castable():
    var a = affects()
    return TargetTypes.SELF_OK.has(a)

func affects():
    return get_from_stats("Affects", TargetTypes.ANY)

func clone() -> Action:
    var a = Action.new()
    a.shape = shape
    a.effect = effect
    a.display_name = display_name
    a.description = description
    a.stats = stats
    a.level = level
    a.type = type
    a.animation_path = animation_path
    return a
