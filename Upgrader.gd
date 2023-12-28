extends Control
@onready var button = $Button
@onready var progress = $TextureProgressBar
@onready var light_animation = $Sprite2D
# Called when the node enters the scene tree for the first time.
func _ready():
    button.pressed
    pass # Replace with function body.


func add_progress():
    progress.value = progress.value + 1
    return

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
    pass
