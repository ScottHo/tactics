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

func textAnimation() -> TextAnimation:
    return $CharacterCommon/TextParent/TextAnimation

func texture_resource() -> Texture2D:
    if $CharacterCommon/Sprite != null:
        return $CharacterCommon/Sprite.texture
    return Texture2D.new()

func texture_scale() -> Vector2:
    if $CharacterCommon/Sprite != null:
        return $CharacterCommon/Sprite.scale
    return Vector2(1,1)

func show_death():
    $CharacterCommon/DeathSprite.visible = true
    return
