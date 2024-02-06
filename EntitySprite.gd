class_name EntitySprite extends Node2D

var animationPlayer: AnimationPlayer
var infoTab: EntityInfoTab
var smallHealthBar: TextureProgressBar
var textAnimNode: TextAnimation
var interContainer: Node2D
var points := []
var moved_entities := []
var sprite : Node2D
var custom_sprite: Sprite2D
var do_modulate := false
var modulate_time_delta := 0.0
var time_to_modulate := .4
var modulate_normal := true
var modulate_color := Color.WHITE
var _dash := false
var SE :Node2D
var SW :Node2D
var NE :Node2D
var NW :Node2D
var south_node: Node2D
var north_node: Node2D
signal doneMoving

func _ready():
    animationPlayer = $AnimationPlayer
    infoTab = $CharacterCommon/InfoBoxContainer
    smallHealthBar = $CharacterCommon/SmallHealthBar
    textAnimNode = $CharacterCommon/TextParent/TextAnimation
    sprite = $Sprite
    interContainer = $CharacterCommon/InteractableContainer
    custom_sprite = $CharacterCommon/CustomContainer/Sprite2D
    if sprite.get_child_count() >= 4:
        SE = $Sprite/SE
        SW = $Sprite/SW
        NE = $Sprite/NE
        NW = $Sprite/NW
        SE.visible = true
        SW.visible = false
        NE.visible = false
        NW.visible = false
        return
    elif sprite.get_child_count() >= 2:
        SE = $Sprite/SE
        NE = $Sprite/NE
        SE.visible = true
        NE.visible = false
    return

func _process(delta):
    if not do_modulate:
        return
    modulate_time_delta += delta
    if modulate_time_delta > time_to_modulate:
        modulate_time_delta = 0
        if modulate_normal:
            sprite.modulate = modulate_color
            modulate_normal = false
        else:
            sprite.modulate = Color.WHITE
            modulate_normal = true
    return

func face_direction(vec: Vector2i):
    if sprite.get_child_count() < 2:
        return
    if sprite.get_child_count() < 4:
        SE.visible = false
        NE.visible = false
        if vec == Vector2i(1,0):
            SE.visible = true
            SE.scale = Vector2(1, 1)
            return
        if vec == Vector2i(0,1):
            SE.visible = true
            SE.scale = Vector2(-1, 1)
            return
        if vec == Vector2i(0,-1):
            NE.visible = true
            NE.scale = Vector2(1, 1)
            return
        if vec == Vector2i(-1,0):
            NE.visible = true
            NE.scale = Vector2(-1, 1)
            return
        return
    SE.visible = false
    SW.visible = false    
    NE.visible = false
    NW.visible = false
    if vec == Vector2i(1,0):
        SE.visible = true
        return
    if vec == Vector2i(0,1):
        SW.visible = true
        return
    if vec == Vector2i(0,-1):
        NE.visible = true
        return
    if vec == Vector2i(-1,0):
        NW.visible = true
        return
    return

func movePoints(_points: Array, _moved_entities: Array, dash: bool = false):
    _dash = dash
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
    if shifted_ent != null and not _dash:
        shifted_ent.shift_animation()
    var pos = points.pop_front()
    if pos.x > global_position.x:
        if pos.y > global_position.y:
            face_direction(Vector2i(1,0))
        else:
            face_direction(Vector2i(0,-1))
    else:
        if pos.y > global_position.y:
            face_direction(Vector2i(0,1))
        else:
            face_direction(Vector2i(-1,0))
    var tween = get_tree().create_tween()
    if _dash:
        tween.tween_property(self, "global_position", pos, .1)
    else:
        tween.tween_property(self, "global_position", pos, .3)
    tween.tween_callback(nextMove)
    tween.play()
    return

func play_hit_animation(callback):
    _play_animation(callback, "Hit")
    return

func play_buff_animation(callback):
    _play_animation(callback, "Buff")
    return

func play_ultimate_animation(callback):
    _play_animation(callback, "Ultimate")
    return

func play_special_animation(callback):
    _play_animation(callback, "Special")
    return

func play_attack_animation(callback):
    _play_animation(callback, "Attack")
    return

func _play_animation(callback, animation_name: String):
    if animationPlayer.has_animation(animation_name):
        animationPlayer.queue(animation_name)
        if callback != null:
            animationPlayer.animation_finished.connect(func(_s):
                callback.call(), CONNECT_ONE_SHOT)
    else:
        if callback != null:
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
        animationPlayer.queue("Move")
    return
        
func stop_animations():
    animationPlayer.clear_queue()
    if animationPlayer.has_animation("RESET"):
        animationPlayer.play("RESET")
    return    

func textAnimation() -> TextAnimation:
    return textAnimNode

func texture_scale() -> Vector2:
    if sprite != null:
        return sprite.scale
    return Vector2(1,1)

func update_from_entity(entity: Entity):
    infoTab.update_from_entity(entity)
    smallHealthBar.value = entity.health
    smallHealthBar.max_value = entity.max_health
    return
    
func loop_modulate(color: Color):
    modulate_color = color
    do_modulate = true
    return
    
func stop_modulate():
    do_modulate = false
    sprite.modulate = Color.WHITE
    modulate_normal = true
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
    smallHealthBar.visible = false
    return

func hide_info():
    infoTab.unexpand()
    smallHealthBar.visible = true
    return

func show_custom_sprite(path: String, _scale: Vector2):
    custom_sprite.texture = load(path)
    custom_sprite.scale = _scale
    return

func show_death():
    var tween = get_tree().create_tween()
    tween.tween_property(self, "modulate:a", 0, 1)
    return
