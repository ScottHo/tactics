class_name InteractService extends Node2D

var _state: State
var _enabled: bool = false
var _entity: Entity
var _target: Vector2i
var _map_bfs: MapBFS
var _num_inters := 0

@onready var tileMap: MainTileMap = $"../TileMap"
@onready var highlightMap: HighlightMap = $"../HighlightMap"

signal interactDone

func _ready():
    return

func _input(event):
    if not _enabled:
        return
    if Globals.on_ui:
        clearTargetHighlights()
        return
    if event is InputEventMouseMotion:
        var coords: Vector2i = tileMap.globalToPoint(get_global_mouse_position())
        if _target != coords:
            clearTargetHighlights()
            _target = coords
            if not _map_bfs.inRange(_target):
                return
            fillTargetHighlights()
    if event is InputEventMouseButton and event.is_pressed():
        match event.button_index:
            MOUSE_BUTTON_LEFT:
                if not _map_bfs.inRange(_target):
                    return
                var _inter: Interactable = _state.interactable_on_tile(_target)
                if _inter == null and _entity.interactable == null:
                    print_debug("Could not find interactable")
                    return
                if _inter == null and _entity.interactable != null:
                    print_debug("Attempting to place interactable at " + str(_target))
                    if _state.entity_on_tile(_target):
                        return
                    _inter = _entity.interactable
                    _state.add_interactable(_inter)
                    _inter.sprite.get_parent().remove_child(_inter.sprite)
                    $"..".add_child(_inter.sprite)
                    _inter.sprite.global_position = tileMap.pointToGlobal(_target)
                    _inter.sprite.scale = _inter.sprite.scale*4
                    _inter.location = _target
                    _inter.drop_effect.call(_entity)
                    
                    _entity.interactable = null
                    print_debug("Interactable placed")
                    interactDone.emit()
                    finish()
                    return
                if _entity.interactable != null and _inter.storable:
                    print_debug("Already has item")
                    return
                print_debug("Interact with" + _inter.display_name)
                _inter.effect.call(_entity)
                _state.remove_interactable(_inter)                
                if _inter.storable:
                    print_debug("Interactable Stored")
                    _entity.add_iteractable(_inter)
                interactDone.emit()
                finish()
                return
    return

func setState(state: State):
    _state = state
    return

func fillTargetHighlights():
    highlightMap.highlightVec(_target, Highlights.RED)
    return

func clearTargetHighlights():
    if _map_bfs.inRange(_target):
        highlightMap.highlightVec(_target, Highlights.PURPLE)
    else:
        highlightMap.highlightVec(_target, Highlights.EMPTY)
    _target = Vector2i(999,999)
    return

func maxRange() -> int:
    return 1

func finish():
    if _enabled:
        if _map_bfs != null:
            _map_bfs.resetHighlights(false)
        _enabled = false
    return

func spawn_interactable(mission: Mission):
    if _num_inters >= len(mission.buffs):
        return Vector2i(999,999)
    var tiles: Array = tileMap.all_tiles()
    tiles.shuffle()
    var i = 0
    while true:
        i += 1
        if i > len(tiles):
            print_debug("No tiles available to spawn interactable")
            break
        if _state.entity_on_tile(tiles[i]):
            continue
        if _state.interactable_on_tile(tiles[i]):
            continue
        setup_interactable_for_level(mission.buffs[_num_inters], tiles[i])
        return tiles[i]
    return Vector2i(999,999)

func setup_interactable_for_level(inter: Interactable, location: Vector2i, increment=true):
    print_debug("Spawning Interactable at " + str(location))    
    inter.location = location
    var sprite: InteractableSprite  = load(inter.sprite_path).instantiate()
    sprite.load_texture(inter.icon_path, inter.color)
    inter.set_sprite(sprite)
    get_parent().add_child(sprite)
    sprite.global_position = tileMap.pointToGlobal(inter.location)
    _state.add_interactable(inter)
    if increment:
        _num_inters += 1
    return

func start(entity: Entity):
    _entity = entity
    _map_bfs = MapBFS.new()
    _map_bfs.init(_entity.location, 1, tileMap, highlightMap, Highlights.PURPLE, _state, MapBFS.BFS_MODE.Interact)
    _map_bfs.resetHighlights(true)
    _enabled = true
    return
