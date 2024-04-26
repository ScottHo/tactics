class_name AnimationTester extends Node2D

@onready var grid = $GridContainer
@onready var spriteParent: Node2D = $Node2D
var entities := []
var page := 1
var audio_path := ""

signal entity_selected

func _ready():
    entities = []
    for bot in EntityFactory.Bot.values():
        entities.append(EntityFactory.create_bot(bot))
    entities.append(EntityFactory.create_boss_1_f())
    for i in range(len(EntityFactory.Bot.values()) + 1):
        var control = Control.new()
        grid.add_child(control)
        control.add_child(Button.new())
        button(control).pressed.connect(func():
            show_entity(i))
        button(control).icon = load(entities[i].icon_path)
        button(control).scale = Vector2(.2, .2)
        
    $Reset.pressed.connect(func():
        var es: EntitySprite = _animation_setup()
        if es != null:
            es.stop_animations())
    $Move.pressed.connect(func():
        var es: EntitySprite = _animation_setup()
        if es != null:
            es.play_move_animation())
    $Attack.pressed.connect(func():
        var es: EntitySprite = _animation_setup()
        if es != null:
            es.play_attack_animation(null))
    $Special.pressed.connect(func():
        var es: EntitySprite = _animation_setup()
        if es != null:
            es.play_special_animation(null))
    $Ultimate.pressed.connect(func():
        var es: EntitySprite = _animation_setup()
        if es != null:
            es.play_ultimate_animation(null))
    $Hit.pressed.connect(func():
        _animation_setup()
        var es: EntitySprite = _animation_setup()
        if es != null:
            es.play_hit_animation(null)
            var s: EffectsAnimation = load("res://Effects/lightning.tscn").instantiate()
            $Node2D2.add_child(s)
            s.position.y -= 40
            s.done.connect(func():
                $Node2D2.remove_child(s))
        )
    $Buff.pressed.connect(func():
        var es: EntitySprite = _animation_setup()
        if es != null:
            es.play_buff_animation(null)
            var s: EffectsAnimation = load("res://Effects/upgrade_effect.tscn").instantiate()
            $Node2D2.add_child(s)
            s.position.y -= 40
            s.done.connect(func():
                $Node2D2.remove_child(s))
        )
    $HitAudioButton2.pressed.connect(func():
        var s: EffectsAnimation = load("res://Effects/lightning.tscn").instantiate()
        _hit_animation(s)
        )
    $Button.pressed.connect(func():
        $FileDialog.visible = true)
    $FileDialog.file_selected.connect(func(s):
        var wav = AudioLoader.new().loadfile(ProjectSettings.globalize_path(s))
        var asp: AudioStreamPlayer2D = $AudioStreamPlayer2D
        asp.volume_db = float($VolumeAudio.text)
        asp.set_stream(wav)
        $AudioLabel.text = "..." + s.right(20)
        )
    $MusicButton.pressed.connect(func():
        $FileDialog2.visible = true)
    $FileDialog2.file_selected.connect(func(s):
        $MusicLabel.text = "..." + s.right(20)
        var wav = AudioLoader.new().loadfile(ProjectSettings.globalize_path(s))
        var asp: AudioStreamPlayer2D = $MainMusic
        asp.set_stream(wav)
        asp.play()
        )
    $HitAudioButton.pressed.connect(func():
        $FileDialog3.visible = true)
    $FileDialog3.file_selected.connect(func(s):
        $AudioHitLabel.text = "..." + s.right(20)
        var wav = AudioLoader.new().loadfile(ProjectSettings.globalize_path(s))
        var asp: AudioStreamPlayer2D = $HitAudioStream
        asp.volume_db = float($VolumeHitEdit.text)
        asp.set_stream(wav)
        )
    return

func _hit_animation(s):
    $HitAudioStream.stop()
    var es = $Node2D3/DrillBit
    if es.find_child("AudioStreamPlayer2D", true) != null:
        es.find_child("AudioStreamPlayer2D", true).volume_db = -99.0
    es.play_hit_animation(null)
    $Node2D4.add_child(s)
    s.position.y -= 40
    s.done.connect(func():
        $Node2D4.remove_child(s))
    get_tree().create_timer(float($VolumeOffsetEdit.text)).timeout.connect(func():
            $HitAudioStream.play())
    return

func _animation_setup():
    $AudioStreamPlayer2D.stop()
    var es: EntitySprite = get_entity_sprite()
    if es != null:
        if es.find_child("AudioStreamPlayer2D", true) != null:
            es.find_child("AudioStreamPlayer2D", true).volume_db = -99.0
        get_tree().create_timer(float($LineEdit.text)).timeout.connect(func():
            $AudioStreamPlayer2D.play())
    return es

func get_entity_sprite():
    if spriteParent.get_child_count() == 0:
        return
    var es: EntitySprite = spriteParent.get_child(0)
    return es

func button(c) -> Button:
    return c.get_child(0)

func container(idx: int) -> Control:
    return grid.get_child(idx)


func show_entity(idx: int):
    if spriteParent.get_child_count() > 0:
        spriteParent.remove_child(spriteParent.get_child(0))
    var es: EntitySprite = load(entities[idx].sprite_path).instantiate()
    spriteParent.add_child(es)
    $EntityLabel.text = entities[idx].display_name
    return
