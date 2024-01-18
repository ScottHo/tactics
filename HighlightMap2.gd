class_name HighlightMap2 extends TileMap

var _previous_coords := Vector2i(0,0)
var _previous_ent
@onready var tileMap: TileMap = $"../TileMap"

var _state: State
var _show_info := true

func _input(event):
    if event is InputEventMouseMotion:
        var global_mouse: Vector2 = get_global_mouse_position()
        var coords: Vector2i = tileMap.globalToPoint(global_mouse)
        if _previous_coords != coords:
            set_cell(1, _previous_coords, 0, Highlights.EMPTY, 0)
            if _previous_ent != null:
                _previous_ent.hide_info()
                _previous_ent = null
            if tileMap.in_range(coords):
                set_cell(1, coords, 0, Highlights.SELECTED, 0)
            if _show_info:
                _previous_ent = _state.entity_on_tile(coords)
                if _previous_ent != null and _show_info:
                    _previous_ent.show_info()
        _previous_coords = coords
    return

func set_state(state):
    _state = state
    return

func do_show_info():
    _show_info = true
    return

func dont_show_info():
    _show_info = false
    return
