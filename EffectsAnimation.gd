class_name EffectsAnimation extends Sprite2D


signal done

func _ready():
    $AnimationPlayer.animation_finished.connect(func(s):
        done.emit())
