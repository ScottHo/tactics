class_name BuildService extends Node2D

@onready var tileMap: MainTileMap = $"../TileMap"
@onready var highlightMap: HighlightMap = $"../HighlightMap"
var _enabled: = false
var _state: State
var _prev_point: Vector2i = Vector2i(999, 999)
var _prev_quadrant: Vector2i = Vector2i(999, 999)
var _wall: Wall = null

signal wall_found

func _ready():
    return

func _input(event):
    if not _enabled:
        return
    if Globals.on_ui:
        _prev_point = Vector2i(999,999)
        _prev_quadrant = Vector2i(999, 999)
        return
    if event is InputEventMouseMotion:
        var point: Vector2i = tileMap.globalToPoint(get_global_mouse_position())
        var quadrant: Vector2i = tileMap.quadrant(get_global_mouse_position())
        if _prev_point == point and _prev_quadrant == quadrant:
            return
        if not tileMap.in_range(point):
            return
        _prev_point = point
        _prev_quadrant = quadrant
        _wall.visible = true
        var center = tileMap.pointToGlobal(point)
        var offset = Vector2(72.5*quadrant.x, 37.5*quadrant.y - 64)
        if quadrant == Utils.NE_vec or quadrant == Utils.SW_vec:
            _wall.flip(true)
        else:
            _wall.flip(false)
        print_debug(quadrant)
        _wall.global_position = center + offset
        return
    
    if event is InputEventMouseButton and event.is_pressed():
        match event.button_index:
            MOUSE_BUTTON_LEFT:
                if _prev_point == Vector2i(999,999):
                    return
                if _prev_quadrant == Vector2i(999,999):
                    return
                wall_found.emit(_prev_point, _prev_quadrant)
                finish()
                return

func finish():
    _enabled = false
    remove_child(_wall)
    _wall = null
    return

func start():
    _enabled = true
    _wall = load("res://Objects/Wall.tscn").instantiate()
    add_child(_wall)
    _wall.visible = false
    return
