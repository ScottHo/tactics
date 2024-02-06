class_name Special

enum Mechanic { BUFF, SOAK, SPREAD, SPAWN, SPAWN_DICE, DESTROY_TILE, CHANGE_TILE_DICE }
enum Shape { SINGLE, CROSS, SQUARE_3x3, DIAMOND_3x3, OCTAGON }
enum Target { SELF, RANDOM, RANDOM2, ALL, THREAT, SPAWN_CLOSE, SPAWN_RANDOM,
    INTERACTABLES, FARTHEST, RANDOM_NO_ENTITIY, TILE_DICE }

static func is_tile_mechanic(m: int) -> bool:
    return m in [Mechanic.SPAWN_DICE, Mechanic.DESTROY_TILE, Mechanic.CHANGE_TILE_DICE]

var display_name: String 
var description: String
var damage: int
var mechanic: Mechanic
var shape: Shape
var target: Target
var target_interactable: String
var effect = null
var spawns: Array = [] # of Entities
var target_animation: String = ""
var animation_path: String = ""

