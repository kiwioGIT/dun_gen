extends KinematicBody2D

const accel = 5000
const mxspeed = 400
const frict = 5000
var motion = Vector2.ZERO
var side = true
# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var input = Vector2.ZERO

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	input = Vector2.ZERO
	input.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	input.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	if Input.is_action_pressed("ui_right"):
		side = false
	if Input.is_action_pressed("ui_left"):
		side = true
	input = input.normalized()
	get_node("AnimatedSprite").flip_h = side
	if input != Vector2.ZERO:
		motion = motion.move_toward(input * mxspeed, accel * delta)
		get_node("AnimatedSprite").play("run")
	else:
		motion = motion.move_toward(Vector2.ZERO, frict * delta)
		get_node("AnimatedSprite").play("idle")
	motion = move_and_slide(motion)
	pass
