class_name TextAnimation extends Label


var data = []
var tween: Tween
var original_position: Vector2

func _ready():
    original_position = position
    return

func queue_tween(c: Color, t: String):
    data.append([c, t])
    return

func play_tween():
    if len(data) == 0:
        return
    var color_and_text = data.pop_front()
    var c = color_and_text[0]
    var t = color_and_text[1]
    var faded_color = Color.BLACK
    faded_color.a = 0
    tween = get_tree().create_tween()    
    tween.tween_property(self, "position:y", original_position.y, 0)
    tween.tween_property(self, "text", t, 0)    
    tween.tween_property(self, "modulate", c, 0)
    tween.tween_property(self, "position:y", original_position.y-15, 0.15)
    tween.tween_interval(.5)
    tween.tween_property(self, "modulate", faded_color, 0.1)
    tween.tween_callback(play_tween)
    tween.play()
    return

func queue_animation(c, t):
    if tween == null or not tween.is_valid():
        queue_tween(c, t)
        play_tween()
    else:
        queue_tween(c, t)
    return

func update_stat(value: int, stat: String):
    var c = Color.WHITE
    var pre = "+"
    if value < 0:
        c = Color.RED
        pre = ""
    queue_animation(c, pre + str(value)  + " " + stat)
    return

func status_effect(value: int, status: String):
    var c = Color.WHITE
    if value < 0:
        c = Color.RED
    queue_animation(c, status + " " + str(abs(value)))
    return
