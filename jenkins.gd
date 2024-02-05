class_name Jenkins extends Node2D

enum Mood { NORMAL, HAPPY, SAD}

var tutorial_mode := false

func _ready():
    $Timer.timeout.connect(fade_away)
    return

func talk(t: String, mood = Mood.NORMAL, no_fade=false):
    $Timer.stop()
    if not no_fade:
        $Timer.start(10)
    visible = true
    $Container/Sad.visible = false
    $Container/Happy.visible = false
    if mood == Mood.HAPPY:
        $Container/Happy.visible = true
    if mood == Mood.SAD:
        $Container/Sad.visible = true 
    $Label.text = t
    $AnimationPlayer.play("Talk")
    return

func fade_away():
    $Container/Sad.visible = false
    $Container/Happy.visible = false
    if not tutorial_mode:
        $Label.text = ""
        visible = false
    return
    
    
