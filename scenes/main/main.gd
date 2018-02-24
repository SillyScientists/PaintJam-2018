extends Control

export (PackedScene) var next_scene


func _ready():
	OS.set_window_title("Bunker Z")
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
	$ParallaxBackground/popup.show()
	pass # replace with function body


func _on_back_pressed():
	$ParallaxBackground/popup.hide()
	pass # replace with function body

