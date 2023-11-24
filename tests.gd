extends Node2D

func assertEquals(a,b):
    if a == b:
        return
    else:
        assert(false, str(a) + " Does not equal " + str(b))

func _ready():
    $Label.text = "Running"
    test_ID_Dict()
    test_turnService()
    test_actionService()
    $Label.text = "Good"
    return
    
func test_ID_Dict():
    var d  = ID_Dict.new()
    var zero = d.add_data("a")
    var one = d.add_data("b")
        
    assertEquals(zero, 0)
    assertEquals(one, 1)
    assertEquals(d.get_data(0), "a")
    assertEquals(d.get_data(1), "b")
    
    var two = d.add_data("c")
    d.remove_data(0)
    d.remove_data(1)
    assertEquals(d.get_data(0), null)
    assertEquals(d.get_data(1), null)
    assertEquals(d.get_data(2), "c")
    
    var zero2 = d.add_data("d")
    var one2 = d.add_data("e")
    assertEquals(zero, 0)
    assertEquals(one, 1)
    assertEquals(d.get_data(0), "d")
    assertEquals(d.get_data(1), "e")
    return


func test_turnService():
    var ts = TurnService.new()
    var state = State.new()
    for i in range(3):
        var entity = Entity.new()
        entity.speed = 10
        state.addAlly(entity)
    ts.setState(state)
    ts.update()
    assertEquals(ts.next5Turns(), [0,1,2,0,1])
    assertEquals(ts.startNextTurn(), 0)
    assertEquals(ts.startNextTurn(), 1)
    assertEquals(ts.next5Turns(), [2,0,1,2,0])
    var entity = Entity.new()
    entity.speed = 15
    state.addAlly(entity)
    ts.update()
    assertEquals(ts.startNextTurn(), 3)
    assertEquals(ts.startNextTurn(), 0)
    assertEquals(ts.startNextTurn(), 1)
    assertEquals(ts.startNextTurn(), 2)
    assertEquals(ts.startNextTurn(), 3)
    assertEquals(ts.startNextTurn(), 0)
    assertEquals(ts.startNextTurn(), 1)
    assertEquals(ts.startNextTurn(), 2)
    assertEquals(ts.startNextTurn(), 3)
    assertEquals(ts.startNextTurn(), 3)
    return

func test_actionService():
    var _as = ActionService.new()
    var v1 = _as.computeRotatedVectors(Vector2i(2, 1), Vector2i(0, -1))
    var v3 = _as.computeRotatedVectors(Vector2i(2,-1), Vector2i(0, -1))
    assertEquals(v1, Vector2i(1, -2))
    assertEquals(v3, Vector2i(-1, -2))
    v1 = _as.computeRotatedVectors(Vector2i(2, 1), Vector2i(-1, 0))
    v3 = _as.computeRotatedVectors(Vector2i(2, -1), Vector2i(-1, 0))
    assertEquals(v1, Vector2i(-2, -1))
    assertEquals(v3, Vector2i(-2, 1))
    v1 = _as.computeRotatedVectors(Vector2i(2, 1), Vector2i(0, 1))
    v3 = _as.computeRotatedVectors(Vector2i(2, -1), Vector2i(0, 1))
    assertEquals(v1, Vector2i(-1, 2))
    assertEquals(v3, Vector2i(1, 2))
    return
