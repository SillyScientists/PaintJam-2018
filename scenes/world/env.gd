extends Node2D

#TODO : PROPER COLLISIONS
#TODO : PROPER SPAWN POS WHEN GOING THROUGH DOOR

var map = []

var obstacles = [] #type,x,y

var hunters = []
var zombies = []

var player_went_through_door = false

var collision_map = []

var current_map_name = "default.txt"
#var color_map = {"#":"#4286f4","0":"#41f46b","D":"#f44141"}
var texture_map = {}
var texture = load("res://icon.png")#Test

export var tile_size = 64

onready var hunter = preload("res://scenes/entities/hunter/Hunter.tscn")

onready var zombie = preload("res://scenes/entities/zombie/Zombie.tscn")

func load_textures():
	var texture_files = []
	texture_files = [["0","scenes/textures/wall_vault/Kaum_Verfallener_Stein1"],
						 ["1","scenes/textures/wall_vault/Kaum_Verfallener_Stein2"],
						 ["2","scenes/textures/wall_vault/Sehr_Verfallener_Stein1"],
						 ["3","scenes/textures/wall_vault/Sehr_Verfallener_Stein2"],
						 ["4","scenes/textures/wall_vault/Verfallener_Stein1"],
						 ["5","scenes/textures/wall_vault/Verfallener_Stein2"],
						 ["A","scenes/textures/ground/Kaum_Verfallen_Bodenplatte1"],
						 ["B","scenes/textures/ground/Kaum_Verfallen_Bodenplatte2"],
						 ["C","scenes/textures/ground/Verfallene_Bodenplatte_mit_Blut1"],
						 ["D","scenes/textures/ground/Verfallene_Bodenplatte_mit_Mos2"],
						 ["E","scenes/textures/ground/Verfallene_Bodenplatte1"],
						 ["F","scenes/textures/ground/Verfallene_Bodenplatte2"],
						 ["#","scenes/textures/misc/Kaum_Verfallen_Bodenplatte_Mit_Tuer"],
						 ["Test Dead Hunter","scenes/entities/hunter/assets/idle/idle1"],
						 ["Icon","res://icon"]]
	texture_map = {}
	for i in range(texture_files.size()):
		texture_map[texture_files[i][0]] = load(texture_files[i][1] + ".png")

func change_map(map_name):
	current_map_name = map_name
	map = []
	obstacles = []
	
	for i in collision_map:
		remove_child(i)
	collision_map = []
	
	for h in hunters:
		remove_child(h)
	hunters = []
	
	print(current_map_name) 
	map = create_map(load_file(current_map_name))
	load_textures()
	$".".update()


func load_file(file_name):
	var file = File.new()
	file.open("worlds/" + file_name, file.READ)
	var content = file.get_as_text()
	#print("FILE : " + file_name)
	#print("CONTENT : " + content)
	file.close()
	return content
	
func create_map(input):
	var t1 = input.split(";",true) #t1[0] -> Map , t1[1] -> Doors
	var map_cont = t1[0]
	var t2 = t1[1].split("#",true)
	var t3 = []
	collision_map = []
	
	for i in range(t2.size()):
		t3.append(t2[i].split(",",true))
	var n_map = [map_cont,t3]
	
	#OBSTACLES
	var obst = t1[2].split("#",true)
	#print(obst)
	for i in range(obst.size()):
		obstacles.append([obst[i].split(",",true)[0],obst[i].split(",",true)[1],obst[i].split(",",true)[2]])
	
	#ENTITIES (ENEMIES)
	if not t1[3] == "":
		var entities = t1[3].split("#",true)
		print("s0 : " + str(entities))
		for e in entities:
			print(e.split(",",true)[0])
			#Hunters
			if e.split(",",true)[0] == "hunter": #Entity-Name = hunter
				print("s2")
				var spl_e = e.split(",",true)
				var damage = spl_e[1]
				var health = spl_e[2]
				var pos_x = float(spl_e[3])
				var pos_y = float(spl_e[4])
				
				var n_hunter = hunter.instance()
				n_hunter.DAMAGE = int(damage)
				n_hunter.health = int(health)
				n_hunter.global_position.x = pos_x*tile_size+(tile_size/2)
				n_hunter.global_position.y = pos_y*tile_size+(tile_size/2)
				
				hunters.append(n_hunter)
			#Zombies
			if e.split(",",true)[0] == "zombie": #Entity-Name = zombie
				print("s2")
				var spl_e = e.split(",",true)
				var damage = spl_e[1]
				var health = spl_e[2]
				var pos_x = float(spl_e[3])
				var pos_y = float(spl_e[4])
				
				var n_zombie = zombie.instance()
				n_zombie.DAMAGE = int(damage)
				n_zombie.health = int(health)
				n_zombie.global_position.x = pos_x*tile_size+(tile_size/2)
				n_zombie.global_position.y = pos_y*tile_size+(tile_size/2)
				
				zombies.append(n_hunter)
	for h in hunters:
		add_child(h)
	for z in zombies:
		add_child(z)
	
	#COLLISIONS (MAP)
	var counter = 0
	var counter_line = 0
	for i in n_map[0]:
		if i=="0" or i=="1" or i=="2" or i=="3" or i=="4" or i=="5": #WÄNDE
			var phy_bod = RigidBody2D.new()
			var coll = CollisionShape2D.new()
			#coll.polygon.append(Vector2(counter*tile_size,counter_line*tile_size))
			#coll.polygon.append(Vector2(counter*tile_size+tile_size,counter_line*tile_size))
			#coll.polygon.append(Vector2(counter*tile_size+tile_size,counter_line*tile_size+tile_size))
			#coll.polygon.append(Vector2(counter*tile_size,counter_line*tile_size+tile_size))
			#coll.position = Vector2(counter*tile_size,counter_line*tile_size)
			coll.shape = RectangleShape2D.new()
			coll.shape.set_extents(Vector2(tile_size/2, tile_size/2))
			
#			coll.polygon.append(Vector2(0*tile_size,0*tile_size))
#			coll.polygon.append(Vector2(1*tile_size,0*tile_size))
#			coll.polygon.append(Vector2(0*tile_size,1*tile_size))
#			coll.polygon.append(Vector2(1*tile_size,1*tile_size))
			
			phy_bod.set_mode(1)
			phy_bod.gravity_scale = 0
			phy_bod.position = Vector2((counter)*tile_size+(tile_size/2),(counter_line)*tile_size+(tile_size/2))
			
			#coll.scale = Vector2(64,64)
			
			phy_bod.add_child(coll)
			phy_bod.set_physics_process(true)
			
			collision_map.append(phy_bod)
		
		if i == "#": #TÜR
			var phy_bod = RigidBody2D.new()
			var coll = CollisionShape2D.new()
			coll.shape = RectangleShape2D.new()
			coll.shape.set_extents(Vector2(tile_size/4,tile_size/4))
			phy_bod.set_mode(1)
			phy_bod.gravity_scale = 0
			phy_bod.position = Vector2((counter)*tile_size+(tile_size/2),(counter_line)*tile_size+(tile_size/2))
			
			phy_bod.add_child(coll)
			phy_bod.set_physics_process(true)
			
			collision_map.append(phy_bod)
		
		counter = counter + 1
		
		if i == "\n": #NEUE ZEILE
			counter_line = counter_line + 1
			counter = 0
	#COLLISIONS (OBSTACLES)
	for i in range(obst.size()):
		
		#var collOb = Area2D.new()
		var phy_bod = RigidBody2D.new()
		var coll = CollisionShape2D.new()
		
		var spl_obst = obst[i].split(",",true)
		
		var x = int(spl_obst[1])
		var y = int(spl_obst[2])
		
		#print(spl_obst[1])
		#print(spl_obst[2])
		
		#initializing shape
		coll.shape = RectangleShape2D.new()
		coll.shape.set_extents(Vector2(tile_size, tile_size))
		
		#initializing Rigid Body
		phy_bod.set_mode(1)
		phy_bod.gravity_scale = 0
		phy_bod.position = Vector2(x*tile_size,y*tile_size)
#		coll.polygon.append(Vector2(x*tile_size,y*tile_size))
#		coll.polygon.append(Vector2(x*tile_size+tile_size,y*tile_size))
#		coll.polygon.append(Vector2(x*tile_size+tile_size,y*tile_size+tile_size))
#		coll.polygon.append(Vector2(x*tile_size,y*tile_size+tile_size))
		
		phy_bod.add_child(coll)
		phy_bod.set_physics_process(true)
		
		collision_map.append(phy_bod)
		#print("---------------------------")
		#print("X,Y = " + str(x) + " , " + str(y))
		#print("1 Obstacle wurde platziert bei : " + str(phy_bod.position))
		
	for i in collision_map: #Adding every collision object to the scene
		add_child(i)
	
	
	return n_map

func get_at_pos(posx,posy):
	var map_x = int((posx/tile_size)+1)
	var map_y = int((posy/tile_size))
	
	var counter = 0
	var counter_line = 0
	var map_tile = "none"
	for i in map[0]: #Map
		if i == "\n":
			counter_line = counter_line + 1
			counter = 0
		else :
			counter = counter + 1
		if map_x == counter and map_y == counter_line :
			map_tile = i
			break
	
	var obst = "none"
	for i in obstacles: #Obstacles
		if int(i[1]) == map_x-1 and int(i[2]) == map_y:
			obst = i[0]
	
	return [map_tile, obst]
		
func get_door(posx,posy):
	var map_x = int((posx/tile_size)+1)
	var map_y = int((posy/tile_size))
	
	var counter = 0
	var counter_line = 0
	var door_counter = -1
	
	for i in map[0]:
		if i== "\n":
			counter_line = counter_line + 1
			counter = 0
		else:
			counter = counter + 1
		
		if i == "#" :
			door_counter = door_counter + 1
		
		if map_x == counter and map_y == counter_line :
			return map[1][door_counter]
	pass
	


func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	
	map = create_map(load_file(current_map_name))
	load_textures()
	
	pass

func _process(delta):
	# Called every frame. Delta is time since last frame.
	# Update game logic here.
	
	for i in collision_map:
		i.update()
	
	var player_pos_x = int(get_node("Player").get_node("FootPosition").global_position.x)
	var player_pos_y = int(get_node("Player").get_node("FootPosition").global_position.y)
	
#	var counter = 0
#	var counter_line = 0
#	var door_count = -1
#	for i in map[0]:
#		if i == "#" :
#			door_count = door_count + 1
#
#		var distance = sqrt(((player_pos_x-(counter+(tile_size/2)))*(player_pos_x-(counter+(tile_size/2))))+((player_pos_y-(counter_line+(tile_size/2)))*(player_pos_y-(counter_line+(tile_size/2)))))
#
#
#		if distance <= 0.8:
#			if i == "#":
#				print(str(distance))
#				if not player_went_through_door:
#					var next_map = map[1][door_count][0]
#					get_node("Player").global_position.x = float(map[1][door_count][1])*tile_size+(tile_size*0.5)
#					get_node("Player").global_position.y = float(map[1][door_count][2])*tile_size+(tile_size*0.5)
#					change_map(next_map)
#					player_went_through_door = true
#			else :
#				player_went_through_door = false
#		if i == "\n":
#			counter_line = counter_line + 1
#			counter = 0
#		else:
#			counter = counter + 1
#
	#print(str(player_pos_x) + " . " + str(player_pos_y))
	#print(get_at_pos(round(player_pos_x),round(player_pos_y))[0])
	
	
	
	if get_at_pos(round(player_pos_x),round(player_pos_y))[0] == "#":
		if not player_went_through_door:
			var door = get_door(player_pos_x,player_pos_y)
			var next_map = door[0]
			get_node("Player").global_position.x = float(door[1])*tile_size+(tile_size/2)
			get_node("Player").global_position.y = float(door[2])*tile_size+(tile_size/2)
			change_map(next_map)
			player_went_through_door = true
	else:
		player_went_through_door = false
	
	pass


func _draw():
	var counter = 0
	var counter_line = 0
	for i in map[0]: #MAP
		if not i == "\n":
			#draw_rect(Rect2(Vector2(counter*64,counter_line*64),Vector2(64,64)),Color(color_map[i]),true)
			draw_texture_rect(texture_map[i.capitalize()],Rect2(Vector2(counter*tile_size,counter_line*tile_size),Vector2(tile_size,tile_size)),false)
			counter = counter + 1
		if i == "\n":
			counter_line = counter_line + 1
			counter = 0
	for i in range(obstacles.size()):
		draw_texture_rect(texture_map[obstacles[i][0].capitalize()],Rect2(Vector2(int(obstacles[i][1])*tile_size,int(obstacles[i][2])*tile_size),Vector2(tile_size,tile_size)),false)
	
	#for i in collision_map:
		#draw_rect(Rect2(i.position[0],i.position[1],64,64),Color(1,0,0),false)
		#print(i.position)

func _input(ev):
	if ev is InputEventMouseButton:
		print(get_at_pos(ev.position.x,ev.position.y))
		print(ev.position.x,ev.position.y)
