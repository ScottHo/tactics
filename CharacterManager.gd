extends Node2D

@onready var tileMap = $"../TileMap"
@onready var character = $"../CharacterBody2D"
# Called when the node enters the scene tree for the first time.
func _ready():
    pass # Replace with function body.

func _input(event):
    if event is InputEventMouseButton and event.is_pressed():
        match event.button_index:
            MOUSE_BUTTON_RIGHT:
                print("INPUT")
                var x = get_global_mouse_position()
                var p = tileMap.to_local(x)
                var z = tileMap.local_to_map(p)
                var q = tileMap.map_to_local(z)
                var r = tileMap.to_global(q)
                character.move(r)
                #velocity = global_position.direction_to(destination) * SPEED
