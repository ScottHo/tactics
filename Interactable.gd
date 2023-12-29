class_name Interactable extends Node

var display_name: String
var description: String
var effect: Callable
var drop_effect: Callable
var repeated_effect: Callable
var storable: bool
var location: Vector2i
var sprite: InteractableSprite

func set_sprite(s):
    sprite = s
    sprite.inter = self
    return
