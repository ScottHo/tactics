class_name State extends Node

var entities: ID_Dict = ID_Dict.new()
var allies: Array[int] = []
var enemies: Array[int] = []

func addAlly(entity: Entity) -> int:
    var id = entities.add_data(entity)
    allies.append(id)
    return id

func addEnemy(entity: Entity) -> int:
    var id = entities.add_data(entity)
    enemies.append(id)
    return id
