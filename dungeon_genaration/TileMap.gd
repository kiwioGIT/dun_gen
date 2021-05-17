extends TileMap


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
#var closest_dist
#var closest_vec
onready var LIGHT = preload("res://Light2D.tscn")
var mids = []
var red_mids = []
var room_amount = 20
var room_max_size = 15
var room_min_size = 5
var room_max_pos_x = 80
var room_max_pos_y = 50
var blue_mids = []
var spacing = 3

# Called when the node enters the scene tree for the first time.
func _ready():
	pass




func generate_new_dungeon():
	for i in room_amount:
		randomize()
		var yadition = 0
		var xadition = 0
		var plus_minus = get_naturality(rand_range(-10,10))
		var h_or_v = get_naturality(rand_range(-10,10))
		print(h_or_v,plus_minus)
		var iscoliding = true
		var sizex = int(rand_range(room_min_size,room_max_size))
		var sizey = int(rand_range(room_min_size,room_max_size))
		var posx = int(rand_range(-room_max_pos_x,room_max_pos_x))
		var posy = int(rand_range(-room_max_pos_y,room_max_pos_y))
		var iscoliding2 = true
		while(iscoliding):
			var sizex2 = sizex+2*spacing
			var sizey2 = sizey+2*spacing
			iscoliding2 = false
			for x in sizex2:
				for y in sizey2:
					if get_cellv(Vector2(posx+x+xadition-spacing,posy+y+yadition-spacing))==0:
						iscoliding2 = true
						if h_or_v == 1:
							xadition += plus_minus
						else:
							yadition += plus_minus
			iscoliding = iscoliding2
		for x in sizex:
			for y in sizey:
				if get_cellv(Vector2(posx+x+xadition,posy+y+yadition))==-1:
					set_cellv(Vector2(posx+x+xadition,posy+y+yadition),0)
				else:
					set_cellv(Vector2(posx+x+xadition,posy+y+yadition),0)
				if posx+x == posx+int(sizex/2) and posy+y == posy+int(sizey/2):
					mids.append(Vector2(posx+x+xadition,posy+y+yadition))
	var mid_to_turn_red = int(rand_range(0,room_amount))
	set_cellv(mids[mid_to_turn_red],1)
	set_blue_mids()
	while(blue_mids.size() > 0):
		connect_closest_pieces()
	change_to_stone()
	place_light()
	get_parent().get_node("p").position = mids[mid_to_turn_red]*16



func change_to_stone():
	var curent_stone_check = Vector2(room_max_pos_x*2,room_max_pos_y*2)
	for ch in room_max_pos_x*room_max_pos_y*16:
		if get_cellv(curent_stone_check)==-1 and get_cellv(Vector2(curent_stone_check.x,curent_stone_check.y+1))==1:
			set_cellv(curent_stone_check,4)
			if get_cellv(Vector2(curent_stone_check.x,curent_stone_check.y-1))==-1:
				set_cellv(Vector2(curent_stone_check.x,curent_stone_check.y-1),5)
		if get_cellv(curent_stone_check)==-1 and get_cellv(Vector2(curent_stone_check.x,curent_stone_check.y-1))==1:
			set_cellv(curent_stone_check,6)
		if get_cellv(curent_stone_check)==-1 and (get_cellv(Vector2(curent_stone_check.x+1,curent_stone_check.y))==1):
			set_cellv(curent_stone_check,10)
		if get_cellv(curent_stone_check)==-1 and (get_cellv(Vector2(curent_stone_check.x-1,curent_stone_check.y))==1):
			set_cellv(curent_stone_check,11)
		if get_cellv(curent_stone_check)==6 and (get_cellv(Vector2(curent_stone_check.x+1,curent_stone_check.y))==1):
			set_cellv(curent_stone_check,12)
		if get_cellv(curent_stone_check)==6 and (get_cellv(Vector2(curent_stone_check.x-1,curent_stone_check.y))==1):
			set_cellv(curent_stone_check,13)
		if get_cellv(curent_stone_check)==5 and (get_cellv(Vector2(curent_stone_check.x+1,curent_stone_check.y))==1):
			set_cellv(curent_stone_check,14)
		if get_cellv(curent_stone_check)==5 and (get_cellv(Vector2(curent_stone_check.x-1,curent_stone_check.y))==1):
			set_cellv(curent_stone_check,15)

		curent_stone_check.x -= 1
		if curent_stone_check.x < -room_max_pos_x*2:
			curent_stone_check.x = room_max_pos_x*2
			curent_stone_check.y -= 1

func place_light():
	for m in mids:
		var new_light = LIGHT.instance()
		new_light.position = m*16
		add_child(new_light)


func fill_red_from_bot():
	var curent_red_check = Vector2(room_max_pos_x*2,room_max_pos_y*2)
	for ch in room_max_pos_x*room_max_pos_y*16:
		if (get_cellv(curent_red_check)==0):
			if get_cellv(Vector2(curent_red_check.x+1,curent_red_check.y))==1 or get_cellv(Vector2(curent_red_check.x-1,curent_red_check.y))==1 or get_cellv(Vector2(curent_red_check.x,curent_red_check.y+1))==1 or get_cellv(Vector2(curent_red_check.x,curent_red_check.y-1))==1:
				set_cellv(curent_red_check,1)
		curent_red_check.x -= 1
		if curent_red_check.x < -room_max_pos_x*2:
			curent_red_check.x = room_max_pos_x*2
			curent_red_check.y -= 1

func connect_with_tiles(start,finish,tile):
	if start.y < finish.y:
		connect_with_tiles_hv(start,finish,tile)
	else:
		connect_with_tiles_vh(start,finish,tile)

func connect_closest_pieces():
	fill_red()
	fill_red_from_bot()
	fill_red()
	fill_red_from_bot()
	fill_red()
	fill_red_from_bot()
	set_red_mids()
	set_blue_mids()
	randomize()
	var c_distance = 9999999999
	var crmid
	var cbmid
	for rmid in red_mids:
		for bmid in blue_mids:
			if get_distancev(rmid,bmid) < c_distance:
				c_distance = get_distancev(rmid,bmid)
				crmid = rmid
				cbmid = bmid
	if blue_mids.size() > 0:
		connect_with_tiles(crmid,cbmid,1)

func connect_random_pieces():
	fill_red()
	fill_red_from_bot()
	fill_red()
	fill_red_from_bot()
	fill_red()
	fill_red_from_bot()
	set_red_mids()
	set_blue_mids()
	randomize()
	var rand_red_mid = int(rand_range(0,red_mids.size()))
	var rand_blue_mid = int(rand_range(0,blue_mids.size()))
	if blue_mids.size() > 0:
		connect_with_tiles(red_mids[rand_red_mid],blue_mids[rand_blue_mid],1)

func fill_red():
	var curent_red_check = Vector2(-room_max_pos_x*2,-room_max_pos_y*2)
	for ch in room_max_pos_x*room_max_pos_y*16:
		if (get_cellv(curent_red_check)==0):
			if get_cellv(Vector2(curent_red_check.x+1,curent_red_check.y))==1 or get_cellv(Vector2(curent_red_check.x-1,curent_red_check.y))==1 or get_cellv(Vector2(curent_red_check.x,curent_red_check.y+1))==1 or get_cellv(Vector2(curent_red_check.x,curent_red_check.y-1))==1:
				set_cellv(curent_red_check,1)
		curent_red_check.x += 1
		if curent_red_check.x > room_max_pos_x*2:
			curent_red_check.x = -room_max_pos_x*2
			curent_red_check.y += 1

func set_red_mids():
	red_mids = []
	for m in mids:
		if get_cellv(m)==1:
			red_mids.append(m)

func set_blue_mids():
	blue_mids = []
	for m in mids:
		if get_cellv(m)==0:
			blue_mids.append(m)


func get_distancev(vector_1,vector_2):
	var f = vector_1-vector_2
	return sqrt(pow(f.x,2)+pow(f.y,2))

func get_naturality(tona):
	return tona/abs(tona)

func connect_with_tiles_hv(start,finish,tile):
	while(start != finish):
		if start.x != finish.x:
			start.x -= get_naturality(start.x - finish.x)
		else:
			start.y -= get_naturality(start.y - finish.y)
		set_cellv(start,tile)

func connect_with_tiles_vh(start,finish,tile):
	while(start != finish):
		if start.y != finish.y:
			start.y -= get_naturality(start.y - finish.y)
		else:
			start.x -= get_naturality(start.x - finish.x)
		set_cellv(start,tile)

func _process(delta):
	if Input.is_action_just_pressed("g"):
		clear()
		var mids = []
		var red_mids = []
		var blue_mids = []
		generate_new_dungeon()
	if Input.is_action_just_pressed("f"):
		print(get_cellv(get_parent().get_node("p").position/16+Vector2(1,-1)))
	pass
