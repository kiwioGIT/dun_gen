extends TileMap


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var closest_dist
var closest_vec
var mids = []
var red_mids = []
var room_amount = 12
var room_max_size = 10
var room_min_size = 3
var room_max_pos_x = 40
var room_max_pos_y = 25
var blue_mids = []
var sizes = []
var poses = []

# Called when the node enters the scene tree for the first time.
func _ready():
	for i in room_amount:
		randomize()
		var sizex = int(rand_range(room_min_size,room_max_size))
		var sizey = int(rand_range(room_min_size,room_max_size))
		sizes.append(Vector2(sizex,sizey))
		var posx = int(rand_range(-room_max_pos_x,room_max_pos_x))
		var posy = int(rand_range(-room_max_pos_y,room_max_pos_y))
		
		poses.append(Vector2(posx,posy))
		for x in sizex:
			for y in sizey:
				if get_cellv(Vector2(posx+x,posy+y))==-1:
					set_cellv(Vector2(posx+x,posy+y),0)
				else:
					set_cellv(Vector2(posx+x,posy+y),-1)
				if posx+x == posx+int(sizex/2) and posy+y == posy+int(sizey/2):
					mids.append(Vector2(posx+x,posy+y))
	print(mids)
	for mid_pos in mids:
		var closest_dist
		var closest_vec
		for mid_pos2 in mids:
				if (closest_dist == null or get_distancev(mid_pos,mid_pos2) < closest_dist) and mid_pos != mid_pos2:
					closest_dist = get_distancev(mid_pos,mid_pos2)
					closest_vec = mid_pos2
		connect_with_tiles(mid_pos,closest_vec,0)
	var mid_to_turn_red = int(rand_range(0,room_amount))
	set_cellv(mids[mid_to_turn_red],1)
	set_blue_mids()
	while(blue_mids.size() > 0):
		connect_pieces()

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
	

func connect_pieces():
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
	print("asdasdasd",red_mids[rand_red_mid])
	
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
	print("red mids ",red_mids)

func set_blue_mids():
	blue_mids = []
	for m in mids:
		if get_cellv(m)==0:
			blue_mids.append(m)
	print("blue mids ",red_mids)

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
