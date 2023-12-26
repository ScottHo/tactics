class_name Utils extends Node

static func set_label_color(label: Label, color: Color):
    var s : LabelSettings = label.get_label_settings()
    if s == null:
        s = LabelSettings.new()
    s.font_color = color
    label.set_label_settings(s)
    return
    
static func movement_color(entity: Entity, moves_left: bool = false) -> Color:
    if moves_left:
        if entity.moves_left == 0:
            return Color.RED
        else:
            return Color.WHITE
    if entity.movement < entity.get_movement():
        return Color.GREEN
    elif entity.movement > entity.get_movement():
        return Color.RED
    else:
        return Color.WHITE

static func range_color(entity: Entity) -> Color:
    if entity.range < entity.get_range():
        return Color.GREEN
    elif entity.range > entity.get_range():
        return Color.RED
    else:
        return Color.WHITE

static func damage_color(entity: Entity) -> Color:
    if entity.damage < entity.get_damage():
        return Color.GREEN
    elif entity.damage > entity.get_damage():
        return Color.RED
    else:
        return Color.WHITE

static func speed_color(entity: Entity) -> Color:
    if entity.speed < entity.get_speed():
        return Color.GREEN
    elif entity.speed > entity.get_speed():
        return Color.RED
    else:
        return Color.WHITE

static func armor_color(entity: Entity) -> Color:
    if entity.armor > 0:
        return Color.GREEN
    elif entity.armor < 0:
        return Color.RED
    else:
        return Color.WHITE

static func threat_color(entity: Entity) -> Color:
    if entity.threat == 5:
        return Color.RED
    elif entity.threat == 4:
        return Color.ORANGE_RED
    elif entity.threat == 3:
        return Color.YELLOW
    else:
        return Color.WHITE

static func health_color(entity: Entity) -> Color:
    if entity.health <= int(entity.max_health*.4):
        return Color.YELLOW
    elif entity.health <= int(entity.max_health*.2):
        return Color.ORANGE_RED
    elif entity.health == 0:
        return Color.RED
    else:
        return Color.WHITE

static func computeRotatedVectors(target: Vector2i, direction: Vector2i) -> Vector2i:
    if direction == Vector2i(0,-1):
        var rotVec = Vector2i(0,0)
        rotVec.x = target.y
        rotVec.y = -target.x
        return rotVec
    if direction == Vector2i(-1,0):
        var rotVec = Vector2i(0,0)
        rotVec.x = -target.x
        rotVec.y = -target.y
        return rotVec
    if direction == Vector2i(0,1):
        var rotVec = Vector2i(0,0)
        rotVec.x = -target.y
        rotVec.y = target.x
        return rotVec
    return target
    
static func findDirection(source: Vector2i, target: Vector2i) -> Vector2i:
    var x_diff = source.x - target.x
    var y_diff = source.y - target.y
    
    if abs(x_diff) >= abs(y_diff):
        if x_diff < 0:
            return Vector2i(1,0)
        return Vector2i(-1,0)
        
    if y_diff < 0:
        return Vector2i(0,1)
    return Vector2i(0,-1)

static func get_target_coords(source: Vector2i, target: Vector2i, shape: Array) -> Array:
    var _target_coords = []
    _target_coords.append(target)
    var direction := Utils.findDirection(source, target)
    for vec in shape:
        var v = Utils.computeRotatedVectors(vec, direction)
        _target_coords.append(target+v)
    return _target_coords
