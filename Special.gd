class_name Special

enum Mechanic { BUFF, SOAK, SPREAD, SPAWN }
enum Shape { SINGLE, CROSS, SQUARE_3x3, DIAMOND_3x3, OCTAGON }
enum Target { SELF, RANDOM, ALL, THREAT, SPAWN_CLOSE, SPAWN_RANDOM }

var display_name: String
var description: String
var damage: int
var mechanic: Mechanic
var shape: Shape
var target: Target
var effect: Callable
var spawns: Array = [] # of Entities

