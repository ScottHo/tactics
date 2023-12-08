class_name VectorHelpers extends Node


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
    var direction := VectorHelpers.findDirection(source, target)
    for vec in shape:
        var v = VectorHelpers.computeRotatedVectors(vec, direction)
        _target_coords.append(target+v)
    return _target_coords
