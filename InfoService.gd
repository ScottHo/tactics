class_name InfoService extends Node2D

var _enabled := false
var _state: State
var _previous_coords: Vector2i = Vector2i(999,999)
@onready var tileMap: MainTileMap = $"../TileMap"

# Called when the node enters the scene tree for the first time.
func _ready():
    pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
    pass

func _input(event):
    if not _enabled:
        return
        
    if event is InputEventMouseMotion:
        var coords: Vector2i = tileMap.globalToPoint(get_global_mouse_position())
        if _previous_coords != coords:
            _previous_coords = coords
            var ent = _state.entity_on_tile(coords)
            if ent != null:
                print("NEW ENT")
            return

func start():
    _enabled = true    
    return

func setState(state: State):
    _state = state
    return
