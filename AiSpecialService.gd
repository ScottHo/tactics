class_name AiSpecialService extends Node2D

var _state: State
var _enabled: bool = false
var _entity: Entity
var _specials: Array
var _targets := []
var _counters := {}

@onready var tileMap: MainTileMap = $"../TileMap"
@onready var highlightMap: HighlightMap = $"../HighlightMap"
@onready var cameraService: CameraService = $"../CameraService"
@onready var effects : Node2D = $Effects

signal special_done

static var layer_0 = [Vector2i(0,0)]
static var layer_1 = [Vector2i(1,0), Vector2i(0,1), Vector2i(-1,0), Vector2i(0,-1)]
static var layer_2 = [Vector2i(1,1), Vector2i(-1,1), Vector2i(-1,-1), Vector2i(1,-1)]
static var layer_3 = [Vector2i(2,0), Vector2i(0,2), Vector2i(-2,0), Vector2i(0,-2)]
static var layer_4 = [Vector2i(2,1), Vector2i(1,2), Vector2i(-1, 2), Vector2i(-2,1),
                      Vector2i(-2,-1), Vector2i(-1,-2), Vector2i(1,-2), Vector2i(2,-1)]

func setState(state: State):
    _state = state
    return

func targets_per_entity(target_entity: Entity) -> Array:
    var vecs = [] 
    if special().shape == Special.Shape.SINGLE:
        vecs.append_array(layer_0)
    if special().shape == Special.Shape.CROSS:
        vecs.append_array(layer_0)
        vecs.append_array(layer_1)
    if special().shape == Special.Shape.SQUARE_3x3:
        vecs.append_array(layer_0)
        vecs.append_array(layer_1)
        vecs.append_array(layer_2)
    if special().shape == Special.Shape.DIAMOND_3x3:
        vecs.append_array(layer_0)
        vecs.append_array(layer_1)
        vecs.append_array(layer_2)
        vecs.append_array(layer_3)
    if special().shape == Special.Shape.OCTAGON:
        vecs.append_array(layer_0)
        vecs.append_array(layer_1)
        vecs.append_array(layer_2)
        vecs.append_array(layer_3)
        vecs.append_array(layer_4)
    for i in len(vecs):
        vecs[i] += target_entity.location
    return vecs

func mechanic_buff_effect():
    for vec in _targets:
        for ent in _state.all_enemies_alive():
            if ent.location == vec:
                special().effect.call(ent)
                break
    return

func mechanic_spread_effect():
    for vec in _targets:
        for ent in _state.all_allies_alive():
            if ent.location == vec:
                ent.loseHP(special().damage)
                special().effect.call(ent)
                break
    return

func mechanic_soak_effect():
    var ents = []
    for vec in _targets:
        for ent in _state.all_allies_alive():
            if ent.location == vec:
                ents.append(ent)
                break
    var damage = float(special().damage)
    damage = floori(damage/len(ents))
    for ent in ents:
        ent.loseHP(damage)
        special().effect.call(ent)
    return

func mechanic_spawn_effect():
    for i in range(len(_targets)):
        spawn_entity(_targets[i], special().spawns[i])
    return

func mechanic_spawn_effect_inters():
    # Remove the interactables before spawning
    var inters = _state.interactables
    for _inter in inters:
        if _inter.display_name == special().target_interactable:
            _state.remove_interactable(_inter)
            _inter.sprite.queue_free()
    for i in range(len(_targets)):
        spawn_entity(_targets[i], special().spawns[0])
    return

func mechanic_change_tile_dice():
    var tiles := tileMap.all_tiles()
    tiles.shuffle()
    for i in range(6):
        tileMap.switch_tile_data(tiles[i*6], Tiles.DICE_1)
        tileMap.switch_tile_data(tiles[i*6+1], Tiles.DICE_2)
        tileMap.switch_tile_data(tiles[i*6+2], Tiles.DICE_3)
        tileMap.switch_tile_data(tiles[i*6+3], Tiles.DICE_4)
        tileMap.switch_tile_data(tiles[i*6+4], Tiles.DICE_5)
        tileMap.switch_tile_data(tiles[i*6+5], Tiles.DICE_6)
    _entity.custom_data = randi_range(1,6)
    _entity.show_custom_sprite("res://Assets/Objects/dice_1.png", Vector2(.1, .1))
    return

func mechanic_damage_if_not_on_dice():
    for vec in _targets:
        for ent in _state.all_allies_alive():
            if ent.location == vec:
                if tileMap.get_cell_tile_data(0, ent.location).get_custom_data("Dice") == _entity.custom_data:
                    ent.nice()
                else:
                    ent.loseHP(special().damage)
                    special().effect.call(ent)
                break
    return

func mechanic_damage_per_dice():
    for vec in _targets:
        for ent in _state.all_allies_alive():
            if ent.location == vec:
                ent.loseHP(_entity.custom_data)
                break
    return

func spawn_entity(location: Vector2i, e: Entity):
    var ent := e.clone()
    var sprite: EntitySprite  = load(ent.sprite_path).instantiate()
    $"..".add_child(sprite)
    sprite.global_position = tileMap.pointToGlobal(location)
    ent.location = location
    if ent.is_ally:
        _state.addAlly(ent)
        ent.set_energy(1)
    else:
        _state.addEnemy(ent)
    ent.sprite = sprite
    ent.update_sprite()
    return

func find_special_targets():
    _targets = []
    if special().target == Special.Target.SELF:
        _targets = targets_per_entity(_entity)
        cameraService.lock_on(_entity.sprite)
        
    if special().target == Special.Target.ALL:
        for ent in _state.all_allies_alive():
            _targets.append_array(targets_per_entity(ent))
        cameraService.reset()

    if special().target == Special.Target.RANDOM:
        var ent = _state.all_allies_alive()[randi_range(0, len(_state.all_allies_alive())-1)]
        _targets = targets_per_entity(ent)
        cameraService.lock_on(ent.sprite)

    if special().target == Special.Target.THREAT:
        var ent = _state.threatOrder()[0]
        _targets = targets_per_entity(ent)
        cameraService.lock_on(ent.sprite)
    
    if special().target == Special.Target.SPAWN_CLOSE:
        spawn_targets(_entity)
        cameraService.lock_on(_entity.sprite)
    
    if special().target == Special.Target.SPAWN_RANDOM:
        var ent = _state.all_allies_alive()[randi_range(0, len(_state.all_allies_alive())-1)]
        spawn_targets(ent)
        cameraService.lock_on(ent.sprite)
    
    if special().target == Special.Target.INTERACTABLES:
        var inters = _state.interactables
        for _inter in inters:
            if _inter.display_name == special().target_interactable:
                _targets.append(_inter.location)
            
    if special().target == Special.Target.TILE_DICE:
        for tile in tileMap.all_tiles():
            if tileMap.get_cell_tile_data(0, tile).get_custom_data("Dice") == _entity.custom_data:
                _targets.append(tile)
        cameraService.reset()

    for v in _targets:
        highlightMap.highlightVec(v, Highlights.RED)
    return

func spawn_targets(ent):
    var numSpawns = len(special().spawns)
    if len(_state.all_enemies_alive()) > 10:
        return
    if numSpawns == 0:
        return
    for vec in targets_per_entity(ent):
        if _state.entity_on_tile(vec) == null and _state.interactable_on_tile(vec) == null:
            _targets.append(vec)
            numSpawns -= 1
            if numSpawns == 0:
                return
    return

func do_special_effect():
    cameraService.stop_lock()
    _entity.action_animation(func():
        ActionCommon.do_action_animation(effects, special(), _targets, tileMap, special_animation_done)
        )
    return

func special_animation_done():
    effects.get_child(0).queue_free()
    if special().mechanic == Special.Mechanic.BUFF:
        mechanic_buff_effect()
    if special().mechanic == Special.Mechanic.SOAK:
        mechanic_soak_effect()
    if special().mechanic == Special.Mechanic.SPREAD:
        mechanic_spread_effect()
    if special().mechanic == Special.Mechanic.SPAWN:
        if special().target == Special.Target.INTERACTABLES:
            mechanic_spawn_effect_inters()
        else:
            mechanic_spawn_effect()
    if special().mechanic == Special.Mechanic.CHANGE_TILE_DICE:
        mechanic_change_tile_dice()
    if special().mechanic == Special.Mechanic.DAMAGE_IF_NOT_ON_DICE:
        mechanic_damage_if_not_on_dice()
    if special().mechanic == Special.Mechanic.DAMAGE_PER_DICE:
        mechanic_damage_per_dice()
    special_done.emit()
    return

func n_special_description():
    var s: Special = next_special(1)
    return  s.description

func n_special_name():
    var s: Special = next_special(1)
    return s.display_name

func nn_special_description():
    var s: Special = next_special(2)
    return  s.description

func nn_special_name():
    var s: Special = next_special(2)
    return s.display_name

func nnn_special_description():
    var s: Special = next_special(3)
    return  s.description

func nnn_special_name():
    var s: Special = next_special(3)
    return s.display_name

func special() -> Special:
    return _specials[counter() % len(_specials)]

func counter():
    # Default at -2, as first turn it will go to -1 and we want to skip first
    return _counters.get(_entity.id, -2)

func cycle_special():
    _counters[_entity.id] = counter() + 1
    return

func next_special(i: int):
    return _specials[(counter() + i) % len(_specials)]
    
func finish():
    for vec in _targets:
        highlightMap.highlightVec(vec, Highlights.EMPTY)
    return
    
func start(entity: Entity, mission: Mission):
    _entity = entity
    _specials = mission.specials
    cycle_special()
    return
     
