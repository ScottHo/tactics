class_name Utils extends Node

static var NE = Vector2i(0,-1)
static var SE = Vector2i(1,0)
static var NW = Vector2i(-1,0)
static var SW = Vector2i(0,1)
static var NE_vec = Vector2i(1,-1)
static var SE_vec = Vector2i(1,1)
static var NW_vec = Vector2i(-1,-1)
static var SW_vec = Vector2i(-1,1)
static var NULL_VEC: Vector2i = Vector2i(9999,9999)


static func set_label_color(label: Label, color: Color):
    label.add_theme_color_override("font_color", Color.WHITE)
    label.modulate = color
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
    if entity.attack_range < entity.get_range():
        return Color.GREEN
    elif entity.attack_range > entity.get_range():
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

static func initiative_color(entity: Entity) -> Color:
    if entity.initiative < entity.get_initiative():
        return Color.GREEN
    elif entity.initiative > entity.get_initiative():
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
            return SE
        return NW
        
    if y_diff < 0:
        return SW
    return NE

static func findDirectionVec(source: Vector2, target: Vector2) -> Vector2i:
    var x = target.x - source.x
    var y = target.y - source.y
    
    if x >= 0:
        if y > 0:
            return SE_vec
        return NE_vec
    else:
        if y >= 0:
            return SW_vec
        return NW_vec


static func get_target_coords(source: Vector2i, target: Vector2i, shape: Array) -> Array:
    var _target_coords = []
    _target_coords.append(target)
    var direction := Utils.findDirection(source, target)
    for vec in shape:
        var v = Utils.computeRotatedVectors(vec, direction)
        _target_coords.append(target+v)
    return _target_coords

static func floor_title(level: int, _floor: int):
    if level <= 7:
        if level == 7:
            return "BRONZE FOUNDRY - BOSS"
        return "BRONZE FOUNDRY - FLOOR " + str(_floor)
    elif level <= 14:
        if level == 14:
            return "IRON FOUNDRY - BOSS"
        return "IRON FOUNDRY - FLOOR " + str(_floor)
    elif level <= 21:
        if level == 21:
            return "STEEL FOUNDRY - BOSS"
        return "STEEL FOUNDRY - FLOOR " + str(_floor)
    else:
        return "THE FINAL FOUNDRY"
