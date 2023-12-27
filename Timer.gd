extends Timer

func disconnect_all():
    for connection in timeout.get_connections():
        timeout.disconnect(connection["callable"])
    return
