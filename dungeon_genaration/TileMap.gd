extends TileMap


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
#var closest_dist
#var closest_vec
var mids = []
var red_mids = []
var room_amount = 24
var room_max_size = 15
var room_min_size = 5
var room_max_pos_x = 80
var room_max_pos_y = 50
var blue_mids = []


# Called when the node enters the scene tree for the first time.
func _ready():
	for i in room_amount:
		randomize()
		var yadition = 0
		var xadition = 0
		var plus_minus = get_naturality(rand_range(-10,10))
		var h_or_v = get_naturality(rand_range(-10,10))
		var iscoliding = true
		var sizex = int(rand_range(room_min_size,room_max_size))
		var sizey = int(rand_range(room_min_size,room_max_size))
		var posx = int(rand_range(-room_max_pos_x,room_max_pos_x))
		var posy = int(rand_range(-room_max_pos_y,room_max_pos_y))
		while(iscoliding):
			for x in sizex+4:
				for y in sizey+4:
					iscoliding = false
					if get_cellv(Vector2(posx+x+xadition,posy+y+yadition))==0:
						iscoliding = true
						if h_or_v == 1:
							xadition += 2*plus_minus
						else:
							yadition += 2*plus_minus
		for x in sizex:
			for y in sizey:
				if get_cellv(Vector2(posx+x+xadition+2,posy+y+yadition+2))==-1:
					set_cellv(Vector2(posx+x+xadition+2,posy+y+yadition+2),0)
				else:
					set_cellv(Vector2(posx+x+xadition,posy+y+yadition),0)
				if posx+x == posx+int(sizex/2) and posy+y == posy+int(sizey/2):
					mids.append(Vector2(posx+x+xadition+2,posy+y+yadition+2))
		print("y add ",yadition)

	print(mids)
	var mid_to_turn_red = int(rand_range(0,room_amount))
	set_cellv(mids[mid_to_turn_red],1)
	set_blue_mids()
	for i in 10:
		delete_badly_placed_tiles()
	while(blue_mids.size() > 0):
		connect_closest_pieces()
	for i in 10:
		post_delete_badly_placed_tiles()


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


func delete_badly_placed_tiles():
	var curent_check = Vector2(-room_max_pos_x*2,-room_max_pos_y*2)
	for ch in room_max_pos_x*room_max_pos_y*16:
		var spaces_around = 0
		if get_cellv(Vector2(curent_check.x-1,curent_check.y)) == 0 and get_cellv(Vector2(curent_check.x,curent_check.y-1)) == 0 and get_cellv(Vector2(curent_check.x-1,curent_check.y-1)) == -1:
			set_cellv(Vector2(curent_check.x-1,curent_check.y),-1)
			
		if get_cellv(Vector2(curent_check.x+1,curent_check.y)) == 0 and get_cellv(Vector2(curent_check.x,curent_check.y-1)) == 0 and get_cellv(Vector2(curent_check.x+1,curent_check.y-1)) == -1:
			set_cellv(Vector2(curent_check.x+1,curent_check.y),-1)
			
		if get_cellv(Vector2(curent_check.x-1,curent_check.y)) == 0 and get_cellv(Vector2(curent_check.x,curent_check.y+1)) == 0 and get_cellv(Vector2(curent_check.x-1,curent_check.y+1)) == -1:
			set_cellv(Vector2(curent_check.x-1,curent_check.y),-1)
			
		if get_cellv(Vector2(curent_check.x+1,curent_check.y)) == 0 and get_cellv(Vector2(curent_check.x,curent_check.y+1)) == 0 and get_cellv(Vector2(curent_check.x+1,curent_check.y+1)) == -1:
			set_cellv(Vector2(curent_check.x+1,curent_check.y),-1)
		
		if get_cellv(Vector2(curent_check.x+1,curent_check.y))==-1:
			spaces_around+=1
		if get_cellv(Vector2(curent_check.x-1,curent_check.y))==-1:
			spaces_around+=1
		if get_cellv(Vector2(curent_check.x,curent_check.y+1))==-1:
			spaces_around+=1
		if get_cellv(Vector2(curent_check.x,curent_check.y-1))==-1:
			spaces_around+=1
		if spaces_around >= 3:
			 set_cellv(curent_check,-1)

func post_delete_badly_placed_tiles():
	var curent_check = Vector2(-room_max_pos_x*2,-room_max_pos_y*2)
	for ch in room_max_pos_x*room_max_pos_y*16:
		var spaces_around = 0
		
		if get_cellv(Vector2(curent_check.x+1,curent_check.y))==-1:
			spaces_around+=1
		if get_cellv(Vector2(curent_check.x-1,curent_check.y))==-1:
			spaces_around+=1
		if get_cellv(Vector2(curent_check.x,curent_check.y+1))==-1:
			spaces_around+=1
		if get_cellv(Vector2(curent_check.x,curent_check.y-1))==-1:
			spaces_around+=1
		if spaces_around >= 3:
			 set_cellv(curent_check,-1)

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
	
	pass
