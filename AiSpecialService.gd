class_name AiSpecialService extends Node2D

var _state: State
var _enabled: bool = false
var _entity: Entity

@onready var tileMap: MainTileMap = $"../TileMap"
@onready var highlightMap: HighlightMap = $"../HighlightMap"

func setState(state: State):
    _state = state
    return

func finish():
    return
    
func start(entity: Entity):
    _entity = entity
    return
     
