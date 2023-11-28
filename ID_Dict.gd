class_name ID_Dict


var _data: Dictionary = {}
var _missing_ids: Array[int] = []


func add_data(obj) -> int:
    if len(_missing_ids) > 0:
        var _id = _missing_ids.pop_front() 
        _data[_id] = obj
        return _id
    else:
        var _id = len(_data)
        _data[_id] = obj
        return _id

func remove_data(id: int):
    _data.erase(id)
    _missing_ids.append(id)
    return
        
func get_data(id: int):
    if _data.has(id):
        return _data[id]
    return null

func has_data(id: int):
    return _data.has(id)

func allKeys() -> Array:
    return _data.keys()

func allData() -> Array:
    return _data.values()
