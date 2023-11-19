class_name EntitySprite extends CharacterBody2D

const MOTION_SPEED = 30 # Pixels/second.
const FRICTION_FACTOR = 0.89

var original_position
var target_position
var moving = false
var shouldMove = false
var points = []
var step
signal doneMoving

func _process(_delta):
    if not moving:
        if shouldMove:
            move(points.pop_front())
            if len(points) == 0:
                shouldMove = false
                doneMoving.emit()
                

func _physics_process(_delta):
    if moving:
        step += 1        
        global_position = original_position.lerp(target_position, .05*step)
        if step == 20:
            moving = false  

func setLabel(s):
    $Label.text = s
    return

func movePoints(_points: Array):
    points = _points
    shouldMove = true
    move(points.pop_front())
    return


func move(pos):
    original_position = global_position
    target_position = pos
    step = 0
    moving = true
    return
