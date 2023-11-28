class_name Entity extends Node

var health: int
var movement: int
var sprite: Node2D
var speed: int # 10 is average, per 100 "cycles"
var location: Vector2i

func loseHP(hp):
    health -= hp
    if health < 0:
        health = 0
    sprite.setHP(health)
    return
