class_name TextAnimation extends Label

@onready var animationPlayer := $AnimationPlayer

var data = []

func _ready():
    animationPlayer.animation_changed.connect(switch_data)

func switch_data(_old, _new):
    var color_and_text = data.pop_front()
    set_color(color_and_text[0])
    text = color_and_text[1]
    return

func queue_animation(c, t):
    data.append([c, t])    
    if animationPlayer.is_playing():
        animationPlayer.queue("Float")
    else:
        switch_data("", "")
        animationPlayer.play("Float")
    return

func lose_health(h: int):
    queue_animation(Color.RED, "-" + str(h) + " Health")
    return

func gain_health(h: int):
    queue_animation(Color.GREEN, "+" + str(h) + " Health")
    return

func update_energy(e: int):
    var t = ""
    if e < 0:
        t = "-" + str(e) + " Energy"
    else:
        t = "+" + str(e) + " Energy"
    queue_animation(Color.CYAN, t)
    return

func gain_shields(s: int):
    queue_animation(Color.CYAN, "+" + str(s) + " Shield")
    return

func gain_movement(m: int):
    queue_animation(Color.GOLD, "+" + str(m) + " Movement")
    return

func set_color(c: Color):
    var ani : Animation = animationPlayer.get_animation("Float")
    var idx = ani.find_track(^".:theme_override_colors/font_color", Animation.TYPE_VALUE)
    var k := ani.track_find_key(idx, .55)
    ani.track_set_key_value(idx, k, c)
    return
    
