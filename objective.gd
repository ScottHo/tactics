class_name Objective

enum Trigger {DRAIN_LIFE, ABSORB_DAMAGE, DEAL_DAMAGE, HEAL, MOVE, THREAT}

var description: String
var is_bool: bool = false
var bool_current: bool = false
var is_int: bool = false
var int_target: int = 1
var int_current: int = 0
var formatter : String = "%d / %d"
var trigger: Trigger

func progress_string():
    if is_int:
        return formatter % [int_current, int_target]
    return ""

func completed() -> bool:
    if is_bool:
        return bool_current
    if is_int:
        return int_current >= int_target
    return false

func copy() -> Objective:
    var o = Objective.new()
    o.is_bool = is_bool
    o.description = description
    o.is_bool = is_bool
    o.bool_current = bool_current
    o.is_int = is_int
    o.int_target = int_target
    o.int_current = int_current
    o.formatter = formatter
    o.trigger = trigger
    return o
