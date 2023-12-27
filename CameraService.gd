class_name CameraService extends Node2D

var _right_click_down := false
var max_x := 0.0
var max_y := 0.0
var min_x := 0.0
var min_y := 0.0
@onready var cam = $"../Camera2D"

func _ready():
    max_x = cam.position.x + 1000
    max_y = cam.position.y + 600
    min_x = cam.position.x - 1000
    min_y = cam.position.y - 600
    $Timer.timeout.connect(func():
        cam.position_smoothing_enabled = false
        $Timer.stop())
    return

func _input(event):
    if event is InputEventMouseButton and event.is_pressed():
        match event.button_index:
            MOUSE_BUTTON_RIGHT:
                _right_click_down = true
                return
            MOUSE_BUTTON_WHEEL_UP:
                cam.zoom += Vector2(.05, .05)
                cam.zoom.x = min(cam.zoom.x, 1.1)
                cam.zoom.y = min(cam.zoom.y, 1.1)
                return
            MOUSE_BUTTON_WHEEL_DOWN:
                cam.zoom -= Vector2(.05, .05)
                cam.zoom.x = max(cam.zoom.x, .65)
                cam.zoom.y = max(cam.zoom.y, .65)
                return
    if event is InputEventMouseButton and event.is_released():
        match event.button_index:
            MOUSE_BUTTON_RIGHT:
                _right_click_down = false
                return
    if event is InputEventMouseMotion:
        if _right_click_down:
            var pos = cam.position - event.relative/2.0
            pos.x = min(max_x, pos.x)
            pos.x = max(min_x, pos.x)
            pos.y = min(max_y, pos.y)
            pos.y = max(min_y, pos.y)
            cam.position = pos
            return

func move(pos: Vector2):
    $Timer.start(1)
    var tween = get_tree().create_tween()
    cam.position_smoothing_enabled = true
    tween.tween_property(cam, "position", pos, .2)
    tween.play()
    return
