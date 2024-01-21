class_name Passive

var display_name: String
var description: String
var repeated_effect: Callable = func(e: Entity):
    return
var static_effect: Callable = func(e: Entity):
    return
var aura_effect: Callable = func(e: Entity):
    return
var global_effect: Callable = func(e: Entity):
    return
var is_repeated := false
var is_static := false
var is_aura := false


func clone():
    var p = Passive.new()
    p.display_name = display_name
    p.description = description
    p.repeated_effect = repeated_effect
    p.static_effect = static_effect
    p.aura_effect = aura_effect
    p.global_effect = global_effect
    p.is_repeated = is_repeated
    p.is_static = is_static
    p.is_aura = is_aura
    return
