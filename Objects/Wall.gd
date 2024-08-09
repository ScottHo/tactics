class_name Wall extends Node2D

func flip(should_flip):
    if should_flip:
        scale = Vector2(-1,1)
    else:
        scale = Vector2(1,1)
    return
