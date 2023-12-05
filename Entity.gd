class_name Entity extends Node

var id: int
var display_name: String
var max_health: int
var health: int
var movement: int
var moves_left: int
var sprite: Node2D
var speed: int # 10 is average, per 100 "cycles"
var location: Vector2i
var threat: int
var damage: int
var attack: Action
var action1: Action
var action2: Action
var immune_count: int
var weakness_count: int
var weakness_amount: int
var movement_penalty: int
var shield_count: int
var shield_amount: int

func loseHP(hp):
    health -= hp
    if health < 0:
        health = 0
    sprite.setHP(health)
    return

func gainHP(hp):
    health += hp
    if health > max_health:
        health = max_health
    sprite.setHP(health)
    return
