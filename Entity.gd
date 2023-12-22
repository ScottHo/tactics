class_name Entity extends Node

var id: int
var display_name: String
var sprite: Node2D
var alive: bool = true
var location: Vector2i
var attack: Action
var action1: Action
var action2: Action
var moves_left: int
var interactable: Interactable

# Variable Stats
var threat: int
var energy: int
var health: int

# Base Stats
var max_health: int
var movement: int
var speed: int # 10 is average, per 100 "cycles"
var damage: int
var armor: int

# Permanent Modifiers
var armor_modifier: int
var movement_modifier: int
var damage_modifier: int
var speed_modifier: int

# Temporary Modifiers
var immune_count: int
var weakness_count: int
var weakness_value: int
var move_buff_count: int
var move_buff_value: int
var move_debuff_count: int
var move_debuff_value: int
var shield_count: int
var shield_value: int

func get_damage() -> int:
    return damage + damage_modifier

func get_movement() -> int:
    return movement + movement_modifier + move_buff_value - move_debuff_value

func get_speed() -> int:
    return speed + speed_modifier

func get_armor() -> int:
    return armor + armor_modifier - weakness_value + shield_value

func get_low_health_threshold() -> int:
    return int(max_health/5)

func loseHP(hp):
    if immune_count > 0:
        immune_count -= 1
        return
    hp -= get_armor()
    lose_hp_modifiers()
    health -= hp
    if health < 0:
        health = 0
    sprite.textAnimation().lose_health(hp)
    return

func lose_hp_modifiers():
    if shield_count > 0:
        shield_count -= 1
        if shield_count == 0:
            shield_value = 0
    if weakness_count > 0:
        weakness_count -= 1
        if weakness_count == 0:
            weakness_value = 0
    return

func gainHP(hp):
    health += hp
    if health > max_health:
        health = max_health
    sprite.textAnimation().gain_health(hp)
    return

func set_max_hp(hp):
    max_health = hp
    return

func gainThreat(t):
    threat += t
    if threat > 5:
        threat = 5
    return

func loseThreat(t):
    threat -= t
    if threat < 0:
        threat = 0
    return

func setThreat(t):
    threat = t
    return
