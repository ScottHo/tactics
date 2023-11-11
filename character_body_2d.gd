extends CharacterBody2D

const MOTION_SPEED = 30 # Pixels/second.
const FRICTION_FACTOR = 0.89

var original_position
var target_position
var moving = false
var step 

func _physics_process(_delta):
    if moving:
        step += 1        
        global_position = original_position.lerp(target_position, .05*step)
        if step == 20:
            moving = false  
        
func move(pos):
    print(pos)
    print(global_position)
    original_position = global_position
    target_position = pos
    step = 0
    moving = true
    return
