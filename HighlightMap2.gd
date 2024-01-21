class_name HighlightMap2 extends TileMap

var _previous_coords := Vector2i(0,0)
var _previous_ent
@onready var tileMap: TileMap = $"../TileMap"

var _state: State
var _show_info := true
var _map_bfs = MapBFS.new()

func _input(event):
    if event is InputEventMouseMotion:
        var global_mouse: Vector2 = get_global_mouse_position()
        var coords: Vector2i = tileMap.globalToPoint(global_mouse)
        if _previous_coords != coords:
            for t in tileMap.all_tiles():
                set_cell(1, t, 0, Highlights.EMPTY, 0)
            if _previous_ent != null:
                _previous_ent.hide_info()
                _previous_ent = null
            if tileMap.in_range(coords):
                set_cell(1, coords, 0, Highlights.SELECTED, 0)
            if _show_info and not Globals.in_action:
                _previous_ent = _state.entity_on_tile(coords)
                if _previous_ent != null and _show_info:
                    _previous_ent.show_info()
                    _map_bfs.init(coords, _previous_ent.get_movement(), tileMap, self, Highlights.MOVEMENT, _state, MapBFS.BFS_MODE.Show)
                    _map_bfs.resetHighlights(true, false)
                    show_passive(coords)
                    
        _previous_coords = coords
    return

func show_passive(coords):
    if _previous_ent.passive != null:
        if _previous_ent.passive.is_aura:
            var vecs = [Vector2i(1,0), Vector2i(0,1), Vector2i(0,-1), Vector2i(-1,0),
                        Vector2i(1,1), Vector2i(1,-1), Vector2i(-1,-1), Vector2i(-1,1)]
            for vec in vecs:
                set_cell(1, coords + vec, 0, Highlights.PASSIVE, 0)
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

func highlightVec(location, color):
    if tileMap.in_range(location):
        set_cell(1, location, 0, color, 0)
    return
