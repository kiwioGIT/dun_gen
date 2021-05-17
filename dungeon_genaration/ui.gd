extends Control


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
# Called when the node enters the scene tree for the first time.
onready var gun = get_parent().get_node("Node2D")
onready var can = get_node("CanvasLayer")
var gg = 10
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var am = str(gun.ammo)
	can.get_node("Label").text = "AMMO "+am+"/"+str(gun.max_ammo)
	if gun.load_time > 0:
		get_node("CanvasLayer/reloadicon").visible = true
		get_node("CanvasLayer/reloadicon").play("roll")
	else:
		get_node("CanvasLayer/reloadicon").visible = false
	var b_loaded = gun.bullets_loaded
	if b_loaded < 6:
		can.get_node("buuuet6").visible = false
	else:
		can.get_node("buuuet6").visible = true
	if b_loaded < 5:
		can.get_node("buuuet5").visible = false
	else:
		can.get_node("buuuet5").visible = true
	if b_loaded < 4:
		can.get_node("buuuet4").visible = false
	else:
		can.get_node("buuuet4").visible = true
	if b_loaded < 3:
		can.get_node("buuuet3").visible = false
	else:
		can.get_node("buuuet3").visible = true
	if b_loaded < 2:
		can.get_node("buuuet2").visible = false
	else:
		can.get_node("buuuet2").visible = true
	if b_loaded < 1:
		can.get_node("buuuet").visible = false
	else:
		can.get_node("buuuet").visible = true
