class_name MainTileMap extends TileMap

static var MIN_X: int = -1
static var MAX_X: int = 12
static var MIN_Y: int = -4
static var MAX_Y: int = 9

var _all_tiles = []

func globalToPoint(pos: Vector2) -> Vector2i:
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

func all_tiles() -> Array:
    if len(_all_tiles) > 0:
        return _all_tiles.duplicate(true)
    for x in range(MIN_X, MAX_X+1):
        for y in range(MIN_Y, MAX_Y+1):
            var tile_data: TileData = get_cell_tile_data(0, Vector2i(x,y))
            if tile_data == null:
                continue
            var tile_level: int = tile_data.get_custom_data("Level")
            if tile_level == -1:
                continue
            _all_tiles.append(Vector2i(x,y))
    return _all_tiles.duplicate(true)

func switch_tile_data(point: Vector2i, atlas: Vector2i):
    set_cell(0, point, 1, atlas)
    return


