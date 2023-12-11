class_name EntitySprite extends Node2D

var original_position
var target_position
var moving = false
var shouldMove = false
var points = []
var lerp_step: int = 0
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
        lerp_step += 1
        global_position = original_position.lerp(target_position, .05*lerp_step)
        if lerp_step == 20:
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
    lerp_step = 0
    moving = true
    return

func setMaxHP(hp: int):
    $CharacterCommon/TextureProgressBar.max_value = hp
    return

func setHP(hp: int):
    $CharacterCommon/TextureProgressBar.value = hp
    return

func setLabel(s):
    $CharacterCommon/Label.text = s
    return

func textAnimation() -> TextAnimation:
    return $CharacterCommon/TextParent/TextAnimation
