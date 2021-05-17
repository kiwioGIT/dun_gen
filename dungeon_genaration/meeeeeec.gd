extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var max_ammo = 100
var ammo = 100
var bullets_loaded = 6
var attack_cooldownset = 0.2
var attack_cooldown = 0
var load_time_set = 0.5
var load_time = 0
onready var bullet = preload("res://bullet.tscn")
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	load_time -= delta
	attack_cooldown -= delta
	look_at(get_global_mouse_position())
	if Input.is_action_just_pressed("click") and attack_cooldown < 0 and bullets_loaded > 0 and load_time < 0:
		bullets_loaded -= 1
		var new_bullet = bullet.instance()
		new_bullet.global_position = global_position
		attack_cooldown = attack_cooldownset
		get_parent().get_parent().add_child(new_bullet)
	if Input.is_action_pressed("reload"):
		reload()

func reload():
	if load_time < 0 and bullets_loaded <=6:
		load_time = load_time_set
		bullets_loaded += 1
		ammo -= 1
