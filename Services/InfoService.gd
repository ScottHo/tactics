class_name InfoService extends Node2D

var _enabled := false
var _state: State
var _previous_coords: Vector2i = Utils.NULL_VEC
var _previous_ent: Entity
@onready var tileMap: MainTileMap = $"../TileMap"
@onready var hoverPanel: Panel = $Panel
@onready var hoverLabel: Label = $Panel/Label


func _input(event):
    if not _enabled:
        return
        
    if event is InputEventMouseMotion:
        var global_mouse: Vector2 = get_global_mouse_position()
        var coords: Vector2i = tileMap.globalToPoint(global_mouse)
        if tileMap.in_range(coords):
            if _previous_coords != coords:
                hide_ent()
                _previous_coords = coords
                var ent = _state.entity_on_tile(coords)
                if ent != null:
                    show_ent(ent)
                    hide_panel()
                    return
                else:
                    var inter: Interactable = _state.interactable_on_tile(coords)
                    if inter != null:
                        hoverLabel.text = inter.display_name + "\n\n" + inter.description
                        hoverLabel.reset_size()
                        hoverPanel.size = hoverLabel.size + Vector2(10, 10)
                        hoverPanel.global_position = global_mouse
                        hoverPanel.visible = true
                        return
                    
                    # Nothing on tile
                    hide_all()
        else:
            _previous_coords = coords
            hide_all()
    return

func show_ent(ent: Entity):
    _previous_ent = ent
    return

func hide_ent():
    if _previous_ent != null:
        _previous_ent = null
    return

func hide_panel():
    hoverPanel.visible = false
    return

func hide_all():
    hide_ent()
    hide_panel()
    return

func start():
    #_enabled = true    
    return

func setState(state: State):
    _state = state
    return
