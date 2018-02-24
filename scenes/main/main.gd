extends Control

export (PackedScene) var next_scene
export (PackedScene) var options

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	pass

#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass


func _on_Button3_pressed():
	get_tree().quit()
	pass # replace with function body


func _on_start_pressed():
	#get_tree().change_scene_to(next_scene)
	pass # replace with function body


func _on_options_pressed():
	get_tree().change_scene_to(options)
	pass # replace with function body
