class_name State extends Node

var entities: ID_Dict = ID_Dict.new()
var allies: Array[int] = []
var enemies: Array[int] = []

func get_entity(id: int):
    return entities.get_data(id)

func addAlly(entity: Entity) -> int:
    var id = entities.add_data(entity)
    allies.append(id)
    entity.id = id
    return id

func addEnemy(entity: Entity) -> int:
    var id = entities.add_data(entity)
    enemies.append(id)
    entity.id = id
    return id

func isAlly(entity: Entity) -> bool:
    return allies.has(entity.id) 

func sort_threat(a, b):
    if entities.get_data(a).threat < entities.get_data(b).threat:
        return true
    return false

func threatOrder() -> Array[int]:
    var ret := allies.duplicate()
    ret.sort_custom(sort_threat)
    return ret
