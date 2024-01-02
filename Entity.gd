class_name Entity extends Node

var id: int = -1
var display_name: String
var sprite: Node2D
var alive: bool = true
var location: Vector2i
var attack: Action
var action1: Action
var action2: Action
var moves_left: int
var is_ally: bool
var is_add: bool = false
var interactable: Interactable
var sprite_path: String
var icon_path: String
var description: String

# Variable Stats
var threat: int
var energy: int
var health: int

# Base Stats
var max_health: int
var movement: int
var initiative: int # 10 is average, per 100 "cycles"
var damage: int
var armor: int
var range: int

# Permanent Modifiers
var armor_modifier: int
var movement_modifier: int
var damage_modifier: int
var initiative_modifier: int
var range_modifier: int
var health_modifier: int

# Temporary Modifiers
var immune_count: int
var weakness_count: int
var weakness_value: int
var shield_count: int
var shield_value: int
var crippled_count: int
var crippled_value: int
var damage_buff_count: int
var damage_buff_value: int
var damage_debuff_count: int
var damage_debuff_value: int

func update_sprite():
    if sprite != null:
        sprite.update_from_entity(self)
    return

func get_damage() -> int:
    var ret = damage + damage_modifier
    if ret < 0:
        ret = 0
    return ret

func get_movement() -> int:
    var ret = movement + movement_modifier - crippled_value
    if ret < 0:
        ret = 0
    return ret

func get_range() -> int:
    var ret = range + range_modifier
    if ret < 1:
        ret = 1
    return ret

func get_initiative() -> int:
    var ret = initiative + initiative_modifier
    if ret < 0:
        ret = 0
    return ret

func get_armor() -> int:
    return armor + armor_modifier - weakness_value + shield_value

func get_low_health_threshold() -> int:
    return int(get_max_health()/5)

func get_max_health():
    return max_health + health_modifier

func lose_all_buffs():
    if damage_buff_count > 0:
        damage_buff_count -= 1
    if damage_debuff_count > 0:
        damage_debuff_count -= 1
    if immune_count > 0:
        immune_count -= 1
    if shield_count > 0:
        shield_count -= 1
    if weakness_count > 0:
        weakness_count -= 1
    if crippled_count > 0:
        crippled_count -= 1
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
        
    if crippled_count == 0:
        crippled_value = 0
    return

func loseHP(hp):
    if immune_count > 0:
        return
    hp -= get_armor()
    health -= hp
    if health < 0:
        health = 0
    sprite.textAnimation().update_stat(-hp, "Health")
    return

func gainHP(hp):
    health += hp
    if health > get_max_health():
        health = get_max_health()
    sprite.textAnimation().update_stat(hp, "Health")
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

func update_energy(value):
    set_energy(energy + value)
    if value > 0:
        sprite.textAnimation().update_stat(value, "Energy")
    return

func update_damage(value):
    damage_modifier += value
    sprite.textAnimation().update_stat(value, "Damage")
    return

func update_range(value):
    range_modifier += value
    sprite.textAnimation().update_stat(value, "Range")
    return
    
func update_initiative(value):
    initiative_modifier += value
    sprite.textAnimation().update_stat(value, "Initiative")
    return

func update_armor(value):
    armor_modifier += value
    sprite.textAnimation().update_stat(value, "Armor")
    return

func update_max_health(value):
    health_modifier += value
    if health > get_max_health():
        health = get_max_health()
    sprite.textAnimation().update_stat(value, "Max Health")
    return

func update_movement(value):
    movement_modifier += value
    sprite.textAnimation().update_stat(value, "Movement")
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

func crippled(value, count):
    crippled_value = value
    crippled_count = count
    sprite.textAnimation().status_effect(-value, "Crippled")
    return

func shielded(value, count):
    shield_value = value
    shield_count = count
    sprite.textAnimation().status_effect(value, "Shielded")
    return

func weakened(value, count):
    weakness_value = value
    weakness_count = count
    sprite.textAnimation().status_effect(value, "Weakened")
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

func clone() -> Entity:
    var e = Entity.new()
    e.display_name = display_name
    e.attack = attack
    if action1 != null:
        e.action1 = action1.clone()
    if action1 != null:
        e.action2 = action2.clone()
    e.is_ally = is_ally
    e.is_add = is_add
    e.sprite_path = sprite_path
    e.icon_path = icon_path
    e.description = description
    e.health = health
    e.max_health = max_health
    e.movement = movement
    e.initiative = initiative
    e.damage = damage
    e.armor = armor
    e.range = range
    return e
    
    
    
    
    
    
    
    
    
