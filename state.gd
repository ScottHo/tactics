class_name State extends Node

var entities: ID_Dict = ID_Dict.new()
var allies: Array[int] = []
var enemies: Array[int] = []
var interactables: Array = []


func all_allies() -> Array:
    var ret = []
    for id in allies:
        ret.append(get_entity(id))
    return ret

func all_enemies() -> Array:
    var ret = []
    for id in enemies:
        ret.append(get_entity(id))
    return ret

func all_allies_alive(no_add: bool = true) -> Array:
    var ret = []
    for id in allies:
        if get_entity(id).alive:
            if no_add and get_entity(id).is_add:
                continue
            ret.append(get_entity(id))
    return ret

func all_enemies_alive() -> Array:
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
    entity.is_ally = true
    return id

func addEnemy(entity: Entity) -> int:
    var id = entities.add_data(entity)
    enemies.append(id)
    entity.id = id
    entity.is_ally = false
    return id

func isAlly(entity: Entity) -> bool:
    return allies.has(entity.id) 

func sort_threat(a, b):
    if a.threat > b.threat:
        return true
    return false

func threatOrder() -> Array:
    var ret := []
    for i in all_allies_alive():
        ret.append(i)
    ret.shuffle()
    ret.sort_custom(sort_threat)
    return ret

func all_allies_dead() -> bool:
    var ret = true
    for id in allies:
        if get_entity(id).is_add:
            continue
        if get_entity(id).alive:
            return false
    return ret

func all_enemies_dead() -> bool:
    for id in enemies:
        if get_entity(id).alive:
            return false
    return true

func boss_dead() -> bool:
    if get_entity(enemies[0]).alive:
        return false
    return true

func entity_on_tile(vector):
    for _entity in entities.allData():
        if _entity.location == vector:
            return _entity
    return null
    
func interactable_on_tile(vector):
    for _interactable in interactables:
        if _interactable.location == vector:
            return _interactable
    return null

func add_interactable(inter: Interactable):
    interactables.append(inter)
    return

func remove_interactable(inter: Interactable):
    interactables.remove_at(interactables.find(inter))
    return

