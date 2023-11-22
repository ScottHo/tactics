class_name TurnService extends Node2D

var _state: State
var _turnNodes: Array[TurnNode] = []
var _turnCache: Array[int] = []

func update():
    _turnNodes = []
    _turnCache = []
    for entity_id in _state.entities.allKeys():
        var turnNode = TurnNode.new()
        var entity: Entity = _state.entities.get_data(entity_id)
        turnNode.entity_id = entity_id
        turnNode.step = entity.speed
        turnNode.total = 0
        _turnNodes.append(turnNode)
    _turnCache.append(findNextTurn())
    _turnCache.append(findNextTurn())
    _turnCache.append(findNextTurn())
    _turnCache.append(findNextTurn())
    _turnCache.append(findNextTurn())
    return

func findNextTurn():
    for turnNode in _turnNodes:
        if turnNode.total >= 100:
            turnNode.total -= 100
            return turnNode.entity_id
    for turnNode in _turnNodes:
        turnNode.total += turnNode.step
    return findNextTurn()

func setState(state: State):
    _state = state
    return

func startNextTurn() -> int:
    var ret: int = _turnCache.pop_front()
    _turnCache.append(findNextTurn())
    return ret

func next5Turns() -> Array[int]:
    return _turnCache
