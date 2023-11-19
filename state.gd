class_name State extends Node

var entities: ID_Dict = ID_Dict.new()
var allies: Array[int] = []
var enemies: Array[int] = []


# Called when the node enters the scene tree for the first time.
func _ready():
    pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
    pass
    
func addAlly(entity: Entity) -> int:
    var id = entities.add_data(entity)
    allies.append(id)
    return id

func addEnemy(entity: Entity) -> int:
    var id = entities.add_data(entity)
    enemies.append(id)
    return id
