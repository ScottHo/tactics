class_name Special

enum Mechanic { SOAK, SPREAD }
enum Shape { SQUARE_3x3 }
enum Target { RANDOM, ALL, THREAT }

var display_name: String
var description: String
var damage: int
var mechanic: Mechanic
var shape: Shape
var target: Target
