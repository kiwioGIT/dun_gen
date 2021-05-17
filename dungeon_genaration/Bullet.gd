extends KinematicBody2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var velocity = Vector2.ZERO
var speed = 300

# Called when the node enters the scene tree for the first time.
func _ready():
	var target = get_global_mouse_position()
	look_at(target)
	velocity = position.direction_to(target) * speed
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	velocity = move_and_slide(velocity)
	pass


func _on_Area2D_body_entered(body):
	if body.is_in_group("tilemap"):
		queue_free()
	pass # Replace with function body.
