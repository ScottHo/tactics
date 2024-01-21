class_name HighlightMap extends TileMap

var lastLocation
@onready var tileMap: TileMap = $"../TileMap"

func highlight(entity: Entity):
    clearHighlight()
    if entity:
        lastLocation = entity.location
        set_cell(0, entity.location, 0, Highlights.YELLOW, 0)
    return

func clearHighlight():
    if lastLocation != null:
        set_cell(0, lastLocation, 0, Highlights.EMPTY, 0)
    return

func highlightVec(location, color):
    if tileMap.in_range(location):
        set_cell(0, location, 0, color, 0)
    return
