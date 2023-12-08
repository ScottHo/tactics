class_name HighlightMap extends TileMap

var lastLocation


func highlight(entity: Entity):
    clearHighlight()
    if entity:
        lastLocation = entity.location
        set_cell(0, entity.location, 0, Highlights.GREEN, 0)
    return

func clearHighlight():
    if lastLocation != null:
        set_cell(0, lastLocation, 0, Highlights.EMPTY, 0)
    return

func highlightVec(location, color):
    set_cell(0, location, 0, color, 0)
    return
