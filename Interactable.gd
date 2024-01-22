class_name Interactable extends Node

var cls_name = "Interactable"
var display_name: String
var description: String
var effect: Callable
var drop_effect: Callable
var repeated_effect: Callable
var repeated_end_effect: Callable
var counter := 0
var storable: bool
var location: Vector2i
var icon_path: String
var sprite_path: String
var color: Color = Color.WHITE
var sprite: InteractableSprite

func set_sprite(s):
    sprite = s
    sprite.set_inter(self)
    return

func shallow_copy() -> Interactable:
    var ret = Interactable.new()
    ret.display_name = display_name
    ret.description = description
    ret.effect = effect
    ret.drop_effect = drop_effect
    ret.repeated_effect = repeated_effect
    ret.repeated_end_effect = repeated_end_effect
    ret.storable = storable
    ret.icon_path = icon_path
    ret.sprite_path = sprite_path
    ret.color = color
    return ret
