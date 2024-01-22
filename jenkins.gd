class_name Jenkins extends Node2D

enum Mood { NORMAL, HAPPY, SAD}

var tutorial_mode := false

func _ready():
    $Timer.timeout.connect(fade_away)
    return

func talk(t: String, mood = Mood.NORMAL):
    $Timer.stop()
    $Timer.start(10)
    visible = true    
    $Sad.visible = false
    $Happy.visible = false
    if mood == Mood.HAPPY:
        $Happy.visible = true
    if mood == Mood.SAD:
        $Sad.visible = true 
    $Label.text = t
    $AnimationPlayer.play("Talk")
    return

func fade_away():
    $Sad.visible = false
    $Happy.visible = false
    if not tutorial_mode:
        $Label.text = ""
        visible = false
    return
    
    
