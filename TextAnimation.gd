class_name TextAnimation extends Label

@onready var animationPlayer := $AnimationPlayer

# Called when the node enters the scene tree for the first time.
func _ready():
    return

func play():
    animationPlayer.play("Float")    
    return

func set_color(c: Color):
    var ani : Animation = animationPlayer.get_animation("Float")
    var idx = ani.find_track(^".:theme_override_colors/font_color", Animation.TYPE_VALUE)
    var k := ani.track_find_key(idx, 1)
    ani.track_set_key_value(idx, k, c)
    return
    
