class_name TurnService extends Node2D

var _state: State
var _turnNodes: Array[TurnNode] = []
var _turnCache: Array[int] = []

func update(random=true):
    _turnNodes = []
    _turnCache = []
    for entity_id in _state.entities.allKeys():
        var turnNode = TurnNode.new()
        var entity: Entity = _state.get_entity(entity_id)
        turnNode.entity_id = entity_id
        turnNode.total = 0
        if _state.isAlly(entity) and random:
            turnNode.total = randi_range(0, 80)
        elif random:
            turnNode.total = randi_range(0, 9) + 90
            if Globals.level_debug_mode:
                turnNode.total = 0
        _turnNodes.append(turnNode)
    
    for i in range(7):
        _turnCache.append(findNextTurn())
    return

func update_new():
    for entity_id in _state.entities.allKeys():
        if has_turn_node(entity_id):
            continue
        var turnNode = TurnNode.new()
        var entity: Entity = _state.get_entity(entity_id)
        if entity.alive:
            turnNode.entity_id = entity_id
            _turnNodes.append(turnNode)
    return

func has_turn_node(entity_id: int):
    for node in _turnNodes:
        if node.entity_id == entity_id:
            return true
    return false

func updateDeaths():
    var numberOfDeaths := 0
    var nodesToRemove := []
    for node in _turnNodes:
        if _state.get_entity(node.entity_id).alive:
            continue
        nodesToRemove.append(node)
        while _turnCache.has(node.entity_id):
            _turnCache.pop_at(_turnCache.find(node.entity_id))
            numberOfDeaths += 1
    
    for node in nodesToRemove:
        _turnNodes.pop_at(_turnNodes.find(node))
    for i in range(numberOfDeaths):
        _turnCache.append(findNextTurn())
    return

func findNextTurn():
    for turnNode in _turnNodes:
        if turnNode.total >= 100:
            turnNode.total -= 100
            return turnNode.entity_id
    for turnNode in _turnNodes:
        turnNode.total += _state.get_entity(turnNode.entity_id).get_initiative()
    return findNextTurn()

func setState(state: State):
    _state = state
    return

func startNextTurn() -> int:
    var ret: int = _turnCache.pop_front()
    _turnCache.append(findNextTurn())
    return ret

func next7Turns() -> Array[int]:
    return _turnCache
