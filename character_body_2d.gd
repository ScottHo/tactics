class_name EntitySprite extends CharacterBody2D

var original_position
var target_position
var moving = false
var shouldMove = false
var points = []
var step
signal doneMoving

func _process(_delta):
    if moving:
        return
    if shouldMove:
        if len(points) == 0:
            shouldMove = false
            doneMoving.emit()
            return
        move(points.pop_front())
    return
    
func _physics_process(_delta):
    if moving:
        step += 1
        global_position = original_position.lerp(target_position, .05*step)
        if step == 20:
            moving = false
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

func setMaxHP(hp: int):
    $TextureProgressBar.setMaxHP(hp)
    return

func setHP(hp: int):
    $TextureProgressBar.setHP(hp)
    return

func setLabel(s):
    $TextureProgressBar.setLabel(s)
    return

func setThreat(t):
    $TextureProgressBar.setThreat(t)
    return

func textAnimation() -> TextAnimation:
    return $TextParent/TextAnimation
