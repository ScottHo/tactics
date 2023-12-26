extends Node2D

func assertEquals(a,b):
    if a == b:
        return
    else:
        assert(false, str(a) + " Does not equal " + str(b))
    
func assertIn(a, b: Array):
    if a in b:
        return
    else:
        assert(false, str(a) + " doesn't exists in " + str(b))

func assertNotIn(a, b: Array):
    if a not in b:
        return
    else:
        assert(false, str(a) + " does exists in " + str(b))
        
func _ready():
    $Label.text = "Running"
    test_ID_Dict()
    test_turnService()
    test_vectorHelper()
    test_state()
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
        entity.alive = true
        state.addAlly(entity)
    ts.setState(state)
    ts.update(false)
    assertEquals(ts.next5Turns(), [0,1,2,0,1])
    assertEquals(ts.startNextTurn(), 0)
    assertEquals(ts.startNextTurn(), 1)
    assertEquals(ts.next5Turns(), [2,0,1,2,0])
    var entity = Entity.new()
    entity.speed = 15
    entity.alive = true
    state.addAlly(entity)
    ts.update(false)
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
    
    state.get_entity(0).alive = false
    ts.updateDeaths()
    assertNotIn(0, ts.next5Turns())
    return

func test_vectorHelper():
    var v1 = Utils.computeRotatedVectors(Vector2i(2, 1), Vector2i(0, -1))
    var v3 = Utils.computeRotatedVectors(Vector2i(2,-1), Vector2i(0, -1))
    assertEquals(v1, Vector2i(1, -2))
    assertEquals(v3, Vector2i(-1, -2))
    v1 = Utils.computeRotatedVectors(Vector2i(2, 1), Vector2i(-1, 0))
    v3 = Utils.computeRotatedVectors(Vector2i(2, -1), Vector2i(-1, 0))
    assertEquals(v1, Vector2i(-2, -1))
    assertEquals(v3, Vector2i(-2, 1))
    v1 = Utils.computeRotatedVectors(Vector2i(2, 1), Vector2i(0, 1))
    v3 = Utils.computeRotatedVectors(Vector2i(2, -1), Vector2i(0, 1))
    assertEquals(v1, Vector2i(-1, 2))
    assertEquals(v3, Vector2i(1, 2))
    return

func test_state():
    var state = State.new()
    var ent1 = Entity.new()
    ent1.threat = 2
    var ent2 = Entity.new()
    ent2.threat = 0
    var ent3 = Entity.new()
    ent3.threat = 1
    state.addAlly(ent1)
    state.addAlly(ent2)
    state.addAlly(ent3)
    assertEquals(state.threatOrder(), [ent1, ent3, ent2])
    return
