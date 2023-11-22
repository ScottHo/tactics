class_name MainTileMap extends TileMap

func globalToPoint(pos: Vector2i) -> Vector2:
    return local_to_map(to_local(pos))

func pointToGlobal(point: Vector2i) -> Vector2:
    return to_global(map_to_local(point))
