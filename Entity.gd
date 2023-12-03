class_name Entity extends Node

var id: int
var health: int
var movement: int
var moves_left: int
var sprite: Node2D
var speed: int # 10 is average, per 100 "cycles"
var location: Vector2i
var threat: int

func loseHP(hp):
    health -= hp
    if health < 0:
        health = 0
    sprite.setHP(health)
    return
