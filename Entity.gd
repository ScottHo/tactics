class_name Entity extends Node

# Static
var collection_id: int
var display_name: String
var sprite: EntitySprite
var passive: Passive
var attack: Action
var action1: Action
var action2: Action
var is_ally: bool
var is_add: bool = false
var sprite_path: String
var icon_path: String
var description: String

# Variable
var id: int = -1
var alive: bool = true
var location: Vector2i

var moves_left: int
var skip_next_turn: bool = false
var damage_done := 0
var ultimate_used := false
var interactable: Interactable
var specials_left := 1
var spawn_on_death: Interactable
var custom_data
var threat: int
var energy: int
var health: int

# Passives
var chain_attack: bool = false
var heal_attack: bool = false
var thorns_all: bool = false # Refect flat damage to everyone, for 1 turn
var thorns: bool = false # Reflect flat damage on basic attacks
var dodge_chance: float = 0.0
var wipe_downgrades_chance: float = 0.0

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

# Aura Modifiers
var aura_range_modifier: int = 0
var aura_damage_modifier: int = 0
var aura_shield: int = 0
var aura_crit: float = 0
var aura_regen: int  = 0

# Temporary Modifiers
var immune_count: int
var weakness_count: int
var weakness_value: int
var shield_value: int
var crippled_count: int
var crippled_value: int
var damage_buff_count: int
var damage_buff_value: int
var damage_debuff_count: int
var damage_debuff_value: int

func update_sprite():
    if not check_sprite():
        return
    sprite.update_from_entity(self)
    return

func get_damage() -> int:
    var ret = damage + damage_modifier + aura_damage_modifier
    if ret < 0:
        ret = 0
    return ret

func get_movement() -> int:
    var ret = movement + movement_modifier - crippled_value
    if ret < 0:
        ret = 0
    return ret

func get_range() -> int:
    var ret = range + range_modifier + aura_range_modifier
    if ret < 1:
        ret = 1
    return ret

func get_initiative() -> int:
    var ret = initiative + initiative_modifier
    if ret < 0:
        ret = 1
    return ret

func get_armor() -> int:
    return armor + armor_modifier - weakness_value

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
    if weakness_count > 0:
        weakness_count -= 1
    if crippled_count > 0:
        crippled_count -= 1
    return

func reset_buff_values():
    if weakness_count == 0:
        weakness_value = 0
        
    if damage_buff_count == 0:
        damage_buff_value = 0
        
    if damage_debuff_count == 0:
        damage_debuff_value = 0
        
    if crippled_count == 0:
        crippled_value = 0
    thorns_all = false
    return

func damage_preview(hp) -> int:
    hp -= get_armor()
    if hp < 0:
        hp = 0
    return hp

func loseHP(hp):
    print_debug("Losing HP " + display_name + " " + str(hp))
    if immune_count > 0:
        return
    if dodge_chance > 0:
        if randf() < dodge_chance:
            miss()
            return
    hp = damage_preview(hp)
    if shield_value > hp:
        shielded(-hp)
        shield_value -= hp
        return
    
    if shield_value > 0:
        hp = -shield_value
        shielded(-shield_value)
        shield_value = 0
        
    health -= hp
    if health < 0:
        health = 0
    if not check_sprite():
        return
    sprite.textAnimation().update_stat(-hp, "Health")
    return

func gainHP(hp):
    health += hp
    if health > get_max_health():
        health = get_max_health()
    sprite.textAnimation().update_stat(hp, "Health")
    return

func miss():
    if not check_sprite():
        return
    sprite.textAnimation().other_text("Miss!", Color.WHITE)
    return

func failed():
    if not check_sprite():
        return
    sprite.textAnimation().other_text("Failed.", Color.RED)
    return

func nice():
    if not check_sprite():
        return
    sprite.textAnimation().other_text("Nice!", Color.GREEN)
    return

func custom_text(t: String, c: Color):
    if not check_sprite():
        return
    sprite.textAnimation().other_text(t, c)
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
        if not check_sprite():
            return
        sprite.textAnimation().update_stat(value, "Energy")
    return

func update_damage(value):
    damage_modifier += value
    if not check_sprite():
        return
    sprite.textAnimation().update_stat(value, "Damage")
    return

func update_range(value):
    range_modifier += value
    if not check_sprite():
        return
    sprite.textAnimation().update_stat(value, "Range")
    return
    
func update_initiative(value):
    initiative_modifier += value
    if not check_sprite():
        return
    sprite.textAnimation().update_stat(value, "Initiative")
    return

func update_armor(value):
    armor_modifier += value
    if not check_sprite():
        return
    sprite.textAnimation().update_stat(value, "Armor")
    return

func update_max_health(value):
    health_modifier += value
    if health > get_max_health():
        health = get_max_health()
    if not check_sprite():
        return
    sprite.textAnimation().update_stat(value, "Max Health")
    return

func update_movement(value):
    movement_modifier += value
    if not check_sprite():
        return
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
    if not check_sprite():
        return
    sprite.textAnimation().status_effect(-value, "Crippled")
    return

func shielded(value):
    shield_value = value
    if not check_sprite():
        return
    sprite.textAnimation().status_effect(value, "Shield")
    return

func weakened(value, count):
    weakness_value = value
    weakness_count = count
    if not check_sprite():
        return
    sprite.textAnimation().status_effect(value, "Weakened")
    return

func wipe_downgrades():
    custom_text("Downgrades Wiped", Color.WHITE)
    if damage_modifier < 0:
        damage_modifier = 0
    if range_modifier < 0:
        range_modifier = 0
    if initiative_modifier < 0:
        initiative_modifier = 0
    if movement_modifier < 0:
        movement_modifier = 0
    if armor_modifier < 0:
        armor_modifier = 0
    if health_modifier < 0:
        health_modifier = 0
    return

func add_iteractable(inter: Interactable):
    if not check_sprite():
        return
    interactable = inter
    sprite.add_interactable(inter)
    return

func setup_next_turn():
    if not check_sprite():
        return
    lose_all_buffs()
    if is_ally:
        update_energy(1)
        if interactable != null:
            if interactable.repeated_effect != null:
                interactable.repeated_effect.call(self)
        if passive != null:
            if passive.is_repeated:
                passive.repeated_effect.call(self)
        loseThreat(1)
        if aura_regen > 0:
            gainHP(2)
        if aura_shield > 0:
            shielded(aura_shield)
        if wipe_downgrades_chance > 0:
            if randf() < wipe_downgrades_chance:
                wipe_downgrades()
    moves_left = get_movement()    
    return

func done_turn():
    if is_ally:
        if interactable != null:
            if interactable.repeated_end_effect != null:
                interactable.repeated_end_effect.call(self)
    return

func action_animation(callback):
    if not check_sprite():
        return
    sprite.play_action_animation(callback)
    return

func stop_animations():
    if not check_sprite():
        return
    sprite.stop_animations()
    return
    
func shift_animation():
    if not check_sprite():
        return
    sprite.play_shift_animation()
    return
    
func show_info():
    if not check_sprite():
        return
    sprite.show_info()
    return
    
func hide_info():
    if not check_sprite():
        return
    sprite.hide_info()
    return

func show_custom_sprite(path: String, _scale: Vector2):
    sprite.show_custom_sprite(path, _scale)
    return

func reset_auras():
    aura_range_modifier = 0
    aura_damage_modifier = 0
    aura_shield = 0
    aura_crit = 0.0
    aura_regen = 0
    return
    
func check_sprite():
    if sprite != null:
        return true
    print_debug("ERROR: Sprite did not exist for {0}".format([display_name]))
    print_stack()
    return false
    

func loop_modulate(color: Color):
    if sprite != null:
        sprite.loop_modulate(color)
    return
    
func stop_modulate():
    if sprite != null:
        sprite.stop_modulate()
    return

func clone() -> Entity:
    var e = Entity.new()
    e.display_name = display_name
    e.attack = attack
    if passive != null:
        e.passive = passive.clone()
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
    if spawn_on_death != null:
        e.spawn_on_death = spawn_on_death.shallow_copy()
    return e
    
    
    
    
    
    
    
    
    
