extends Control

var main_instance
var hub_instance
var env_instance
var hub = false

func _ready():
	#var s = ResourceLoader()
	$bg_normal.play()
	main_instance = global.main_scene.instance(2)
	add_child(main_instance)
	

func scene_change():
	if(!hub):
		for i in get_children():
			if(i.name != "bg_normal"):
				remove_child(i)
		
		hub_instance = global.hub_scene.instance(2)
		add_child(hub_instance)
	else:
		env_instance = global.env_scene.instance(2)
		add_child(env_instance)
