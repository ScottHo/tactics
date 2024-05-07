class_name CameraService extends Node2D

var _right_click_down := false
var _left_click_down := false
var max_x := 0.0
var max_y := 0.0
var min_x := 0.0
var min_y := 0.0
var zoom_min := .7
var zoom_max := 1.5
var _target = null
var _moved := false
var original_position: Vector2
var timer = 0
@onready var cam = $"../Camera2D"
@onready var tileMap: MainTileMap = $"../TileMap"

func _ready():
    original_position = cam.position
    max_x = cam.position.x + 1400
    max_y = cam.position.y + 1000
    min_x = cam.position.x - 1000
    min_y = cam.position.y - 600
    $Timer.timeout.connect(func():
        cam.position_smoothing_enabled = false
        $Timer.stop())
    return

func _process(_delta):
    if not _moved and _target != null:
        cam.position = to_local(_target.global_position)
    if _left_click_down:
        timer += 1
    return

func _input(event):
    if event is InputEventMouseButton and event.is_pressed():
        match event.button_index:
            MOUSE_BUTTON_RIGHT:
                _right_click_down = true
                _moved = true
                cam.position_smoothing_enabled = false
                return
            MOUSE_BUTTON_WHEEL_UP:
                cam.zoom += Vector2(.05, .05)
                cam.zoom.x = min(cam.zoom.x, zoom_max)
                cam.zoom.y = min(cam.zoom.y, zoom_max)
                return
            MOUSE_BUTTON_WHEEL_DOWN:
                cam.zoom -= Vector2(.05, .05)
                cam.zoom.x = max(cam.zoom.x, zoom_min)
                cam.zoom.y = max(cam.zoom.y, zoom_min)
                return
            MOUSE_BUTTON_LEFT:
                _left_click_down = true
                return
    if event is InputEventMouseButton and event.is_released():
        match event.button_index:
            MOUSE_BUTTON_RIGHT:
                _right_click_down = false
                return
            MOUSE_BUTTON_LEFT:
                timer = 0
                _left_click_down = false
                return
    if event is InputEventMouseMotion:
        if _right_click_down or (_left_click_down and timer > 30):
            _moved = true
            var pos = cam.position - event.relative*.8
            pos.x = min(max_x, pos.x)
            pos.x = max(min_x, pos.x)
            pos.y = min(max_y, pos.y)
            pos.y = max(min_y, pos.y)
            cam.position = pos
            return
    if event is InputEventMagnifyGesture:
        cam.zoom += (1.0-event.factor)*Vector2(.1, .1)
        cam.zoom.x = min(cam.zoom.x, zoom_max)
        cam.zoom.y = min(cam.zoom.y, zoom_max)
        cam.zoom.x = max(cam.zoom.x, zoom_min)
        cam.zoom.y = max(cam.zoom.y, zoom_min)
        return
    if event is InputEventPanGesture:
        var pos = cam.position - event.delta*.8
        _moved = true
        pos.x = min(max_x, pos.x)
        pos.x = max(min_x, pos.x)
        pos.y = min(max_y, pos.y)
        pos.y = max(min_y, pos.y)
        cam.position = pos

func move(pos: Vector2):
    _moved = false
    $Timer.stop()
    $Timer.start(1.5)
    var tween = get_tree().create_tween()
    cam.position_smoothing_enabled = true
    tween.tween_property(cam, "position", pos, .2)
    tween.play()
    return

func lock_on(node):
    if _moved:
        return
    cam.position_smoothing_enabled = true
    _target = node
    return

func move_to_array(vec2i_array):
    if len(vec2i_array) == 0:
        reset()
        return
    var max_x = -99999
    var min_x = 99999
    var max_y = -99999
    var min_y = 99999
    for vec2 in vec2i_array:
        var p = tileMap.pointToGlobal(vec2)
        min_x = min(p.x, min_x)
        max_x = max(p.x, max_x)
        min_y = min(p.y, min_y)
        max_y = max(p.y, max_y)
    move(Vector2((max_x-min_x)/2.0 + min_x, (max_y-min_y)/2.0 + min_y))
    return

func stop_lock():
    $Timer.stop()
    $Timer.start(.5)
    _target = null
    return

func tween_zoom_in():
    cam.zoom = Vector2(zoom_min, zoom_min)
    var tween = create_tween()
    tween.tween_interval(1.5)
    tween.tween_property(cam, "zoom", Vector2(1,1), .3)
    tween.play()
    return

func reset():
    move(original_position)
    return
