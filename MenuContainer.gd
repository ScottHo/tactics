class_name MenuContainer extends ReferenceRect


func in_bounds() -> bool:
    var v = get_local_mouse_position()
    if 0 < v.x and v.x < size.x and 0 < v.y and v.y < size.y:
        return true
    return false
