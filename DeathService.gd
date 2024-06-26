class_name DeathService extends Node2D

var _state: State
var _deaths_to_process: Array
var _graveyard: Array

@onready var interactService: InteractService = $"../InteractService"

func setState(state: State):
    _state = state
    return

func checkDeaths() -> bool:
    for _ent in _state.all_entities():
        var ent: Entity = _ent
        if ent.health > 0:
            continue
        if ent.id in _graveyard:
            continue
        _deaths_to_process.append(ent)
    return len(_deaths_to_process) > 0

func processDeaths():
    for _ent in _deaths_to_process:
        var ent : Entity = _ent
        ent.alive = false
        doDeathAnimation(ent)
        _graveyard.append(ent.id)
    _deaths_to_process = []
    return

func doDeathAnimation(entity: Entity):
    print_debug(entity.display_name + " Died!")
    entity.sprite.show_death()
    var tween = get_tree().create_tween()
    tween.tween_interval(1)
    tween.tween_property(entity.sprite, "modulate:a", 0, 1)
    tween.tween_callback(func():
        entity.sprite.queue_free()
        if entity.spawn_on_death != null:
            spawn_interactable(entity.spawn_on_death, entity.location)
        entity.location = Vector2i(999,999)
            )
    return

func spawn_interactable(inter, location):
    interactService.setup_interactable_for_level(inter.shallow_copy(), location, false)
    return
