class_name EntitySprite extends Node2D

var points = []
signal doneMoving

func _ready():
    $CharacterCommon.move_child($CharacterCommon/Sprite, 0)
    return

func movePoints(_points: Array):
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

func update_from_entity(entity: Entity):
    $CharacterCommon/InfoBoxContainer.update_from_entity(entity)
    return

func add_interactable(inter: Interactable):
    inter.sprite.get_parent().remove_child(inter.sprite)
    $CharacterCommon/InteractableContainer.add_child(inter.sprite)
    inter.sprite.position = Vector2(0,0)
    inter.sprite.scale = inter.sprite.scale*.5
    inter.location = Vector2(999,999)
    return
