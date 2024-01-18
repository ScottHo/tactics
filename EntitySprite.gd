class_name EntitySprite extends Node2D

var animationPlayer: AnimationPlayer
var infoTab: EntityInfoTab
var textAnimNode: TextAnimation
var interContainer: Node2D
var points := []
var moved_entities := []
var sprite : Node2D
var custom_sprite: Sprite2D

signal doneMoving

func _ready():
    animationPlayer = $AnimationPlayer
    infoTab = $CharacterCommon/InfoBoxContainer
    textAnimNode = $CharacterCommon/TextParent/TextAnimation
    sprite = $Sprite
    interContainer = $CharacterCommon/InteractableContainer
    custom_sprite = $CharacterCommon/CustomContainer/Sprite2D
    return

func movePoints(_points: Array, _moved_entities: Array):
    z_index = 3
    play_move_animation()
    points = _points
    moved_entities = _moved_entities
    nextMove()
    return

func nextMove():
    if len(points) == 0:
        z_index -= 1
        doneMoving.emit()
        return
    var shifted_ent = moved_entities.pop_front()
    if shifted_ent != null:
        shifted_ent.shift_animation()
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

func play_shift_animation():
    var tween = get_tree().create_tween()
    var shifted = position
    shifted.y -= 30
    tween.tween_property(self, "position", shifted, .2)
    tween.tween_property(self, "position", position, .2)
    tween.play()
    return

func play_move_animation():
    if animationPlayer.has_animation("Move"):
        animationPlayer.play("Move")
    return
        
func stop_animations():
    animationPlayer.stop()
    return    

func textAnimation() -> TextAnimation:
    return textAnimNode

func texture_scale() -> Vector2:
    if sprite != null:
        return sprite.scale
    return Vector2(1,1)

func update_from_entity(entity: Entity):
    infoTab.update_from_entity(entity)
    return

func add_interactable(inter: Interactable):
    inter.sprite.get_parent().remove_child(inter.sprite)
    interContainer.add_child(inter.sprite)
    inter.sprite.position = Vector2(0,0)
    inter.sprite.scale = inter.sprite.scale*.25
    inter.location = Vector2(999,999)
    return

func show_info():
    infoTab.expand()
    return

func hide_info():
    infoTab.unexpand()
    return

func show_custom_sprite(path: String, _scale: Vector2):
    custom_sprite.texture = load(path)
    custom_sprite.scale = _scale
    return

func show_death():
    var tween = get_tree().create_tween()
    tween.tween_property(self, "modulate:a", 0, 1)
    return
