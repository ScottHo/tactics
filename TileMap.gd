class_name MainTileMap extends TileMap

static var MIN_X: int = 0
static var MAX_X: int = 11
static var MIN_Y: int = -3
static var MAX_Y: int = 8

func globalToPoint(pos: Vector2i) -> Vector2:
    return local_to_map(to_local(pos))

func pointToGlobal(point: Vector2i) -> Vector2:
    return to_global(map_to_local(point))

func arrayToGlobal(arr: Array) -> Array:
    var poses = []
    for point in arr:
        poses.append(pointToGlobal(point))
    return poses

func in_range(v: Vector2i) -> bool:
    return MIN_X <= v.x and v.x <= MAX_X and MIN_Y <= v.y and v.y <= MAX_Y
