class_name EntitySprite extends Node2D

var animationPlayer: AnimationPlayer
var points = []
signal doneMoving

func _ready():
    animationPlayer = $AnimationPlayer
    return

func movePoints(_points: Array):
    play_move_animation()
    points = _points
    nextMove()
    return

func nextMove():
    if len(points) == 0:
        doneMoving.emit()
        return
    var pos = points.pop_front()
    var tween = get_tree().create_tween()
    tween.tween_property(self, "global_position", pos, .3)
    tween.tween_callback(nextMove)
    tween.play()
    return

func play_action_animation(callback):
    if animationPlayer.has_animation("Action"):
        animationPlayer.play("Action")
        animationPlayer.animation_finished.connect(func(s):
            callback.call(), CONNECT_ONE_SHOT)
    else:
        var timer = get_tree().create_timer(.5)
        timer.timeout.connect(func():
            callback.call()
            , CONNECT_ONE_SHOT)
    return

func play_move_animation():
    if animationPlayer.has_animation("Action"):
        animationPlayer.play("Action")
    return
        
func stop_animations():
    animationPlayer.stop()
    return    

func textAnimation() -> TextAnimation:
    return $CharacterCommon/TextParent/TextAnimation

func texture_scale() -> Vector2:
    if $Sprite != null:
        return $Sprite.scale
    return Vector2(1,1)

func show_death():
    $CharacterCommon/DeathSprite.visible = true
    return

func update_from_entity(entity: Entity):
    $CharacterCommon/InfoBoxContainer.update_from_entity(entity)
    return

func add_interactable(inter: Interactable):
    inter.sprite.get_parent().remove_child(inter.sprite)
    $CharacterCommon/InteractableContainer.add_child(inter.sprite)
    inter.sprite.position = Vector2(0,0)
    inter.sprite.scale = inter.sprite.scale*.25
    inter.location = Vector2(999,999)
    return
