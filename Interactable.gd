class_name Interactable extends Node

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
