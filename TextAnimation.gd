class_name TextAnimation extends Label

@onready var animationPlayer := $AnimationPlayer


func lose_health(h: int):
    set_color(Color.RED)
    text =  "-" + str(h) + " Health"
    play()
    return

func gain_health(h: int):
    set_color(Color.GREEN)
    text = "+" + str(h) + " Health"
    play()
    return

func gain_shields(s: int):
    set_color(Color.CYAN)
    text = "+" + str(s) + " Shield"
    play()
    return

func gain_movement(m: int):
    set_color(Color.PALE_GREEN)
    text = "+" + str(m) + " Movement"
    play()
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
    
