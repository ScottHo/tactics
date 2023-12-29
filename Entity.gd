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
var is_ally: bool
var interactable: Interactable
var level: int
var sprite_path: String
var icon_path: String

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
var range: int

# Permanent Modifiers
var armor_modifier: int
var movement_modifier: int
var damage_modifier: int
var speed_modifier: int
var range_modifier: int
var health_modifier: int

# Temporary Modifiers
var immune_count: int
var weakness_count: int
var weakness_value: int
var shield_count: int
var shield_value: int
var move_buff_count: int
var move_buff_value: int
var move_debuff_count: int
var move_debuff_value: int
var damage_buff_count: int
var damage_buff_value: int
var damage_debuff_count: int
var damage_debuff_value: int

func update_sprite():
    sprite.update_from_entity(self)
    return

func get_damage() -> int:
    var ret = damage + damage_modifier
    if ret < 0:
        ret = 0
    return ret

func get_movement() -> int:
    var ret = movement + movement_modifier + move_buff_value - move_debuff_value
    if ret < 0:
        ret = 0
    return ret

func get_range() -> int:
    var ret = range + range_modifier
    if ret < 1:
        ret = 1
    return ret

func get_speed() -> int:
    var ret = speed + speed_modifier
    if ret < 0:
        ret = 0
    return ret

func get_armor() -> int:
    return armor + armor_modifier - weakness_value + shield_value

func get_low_health_threshold() -> int:
    return int(get_max_health()/5)

func get_max_health():
    return max_health + health_modifier

func loseHP(hp):
    if immune_count > 0:
        return
    hp -= get_armor()
    health -= hp
    if health < 0:
        health = 0
    sprite.textAnimation().lose_health(hp)
    return

func lose_defensive_buffs():
    if immune_count > 0:
        immune_count -= 1
    if shield_count > 0:
        shield_count -= 1
    if weakness_count > 0:
        weakness_count -= 1
    return

func lose_movement_buffs():
    if move_buff_count > 0:
        move_buff_count -= 1
    if move_debuff_count > 0:
        move_debuff_count -= 1
    return

func lose_damage_buffs():
    if damage_buff_count > 0:
        damage_buff_count -= 1
    if damage_debuff_count > 0:
        damage_debuff_count -= 1
    return

func lose_all_buffs():
    lose_movement_buffs()
    lose_defensive_buffs()
    lose_damage_buffs()
    return

func reset_buff_values():
    if weakness_count == 0:
        weakness_value = 0
        
    if shield_count == 0:
        shield_value = 0
        
    if damage_buff_count == 0:
        damage_buff_value = 0
        
    if damage_debuff_count == 0:
        damage_debuff_value = 0
        
    if move_debuff_count == 0:
        move_debuff_value = 0
        
    if move_buff_count == 0:
        move_buff_value = 0
    return

func gainHP(hp):
    health += hp
    if health > get_max_health():
        health = get_max_health()
    sprite.textAnimation().gain_health(hp)
    return

func set_max_health(hp):
    max_health = hp
    return

func set_hp(hp):
    if hp <= 0:
        hp = 0
    if hp >= get_max_health():
        hp = get_max_health()
    health = hp
    return

func set_energy(e):
    energy = e
    if energy < 0:
        energy = 0
    if energy > 5:
        energy = 5
    return

func update_energy(energy_diff):
    set_energy(energy + energy_diff)
    sprite.textAnimation().update_energy(energy_diff)
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

func add_iteractable(inter: Interactable):
    interactable = inter
    sprite.add_interactable(inter)
    return

func setup_next_turn():
    lose_all_buffs()
    moves_left = get_movement()
    if is_ally:
        update_energy(1)
        if interactable != null:
            if interactable.repeated_effect != null:
                interactable.repeated_effect.call(self)
        loseThreat(1)
    return
