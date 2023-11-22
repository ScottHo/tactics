class_name ActionService extends Node2D

var _state: State
var _targetting: bool = false
var _entity: Entity
var _action: Action

@onready var tileMap: MainTileMap = $"../TileMap"
@onready var highlightMap: HighlightMap = $"../HighlightMap"

func _input(event):
    if not _targetting:
        return
    if event is InputEventMouseMotion:
        var coords: Vector2i = tileMap.globalToPoint(get_global_mouse_position())
        highlightMap.set_cell(0, coords, 0, Highlights.RED, 0)
    return

func start(entity: Entity, action: Action):
    _entity = entity
    _action = action
    return
