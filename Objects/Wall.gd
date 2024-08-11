class_name Wall extends Node2D

var _coords: Array = []

func coords():
    return _coords

func set_location(point, quadrant):
    _coords = convert_to_wall_coords(point, quadrant)
    return

static func convert_to_wall_coords(point: Vector2i, quadrant: Vector2i) -> Array:
    var ret = []
    if quadrant == Utils.NE_vec:
        ret = [point, point+Utils.NE]
    elif quadrant == Utils.NW_vec:
        ret = [point, point+Utils.NW]
    elif quadrant == Utils.SE_vec:
        ret = [point, point+Utils.SE]
    elif quadrant == Utils.SW_vec:
        ret = [point, point+Utils.SW]
    ret.sort()
    return ret

func flip(should_flip):
    if should_flip:
        scale = Vector2(-1,1)
    else:
        scale = Vector2(1,1)
    return
