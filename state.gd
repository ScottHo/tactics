class_name State extends Node

var entities: ID_Dict = ID_Dict.new()
var allies: Array[int] = []
var enemies: Array[int] = []

func allAllies() -> Array:
    var ret = []
    for id in allies:
        if get_entity(id).alive:
            ret.append(get_entity(id))
    return ret

func allEnemies() -> Array:
    var ret = []
    for id in enemies:
        if get_entity(id).alive:
            ret.append(get_entity(id))
    return ret

func all_entities() -> Array:
    return entities.allData()

func get_entity(id: int) -> Entity:
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
    if a.threat < b.threat:
        return true
    return false

func threatOrder() -> Array:
    var ret = allAllies()
    allAllies().sort_custom(sort_threat)
    return ret

func all_allies_dead() -> bool:
    var ret = true
    for id in allies:
        if get_entity(id).alive:
            return false
    return ret

func all_enemies_dead() -> bool:
    var ret = true
    for id in enemies:
        if get_entity(id).alive:
            return false
    return ret
