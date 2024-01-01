class_name Special

enum Mechanic { BUFF, SOAK, SPREAD }
enum Shape { SINGLE, SQUARE_3x3, DIAMOND_3x3 }
enum Target { SELF, RANDOM, ALL, THREAT }

var display_name: String
var description: String
var damage: int
var mechanic: Mechanic
var shape: Shape
var target: Target
var effect: Callable
