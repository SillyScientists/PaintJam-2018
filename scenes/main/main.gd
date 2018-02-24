extends Control

export (PackedScene) var next_scene
var size
var button_size


func _ready():
	OS.set_window_title("Bunker Z")
	
	#Initialize size
	size_window()
	
	pass

#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass


func size_window():
	size = OS.get_window_size()
	button_size = $ParallaxBackground/buttons/options.rect_size
	$ParallaxBackground/background.motion_mirroring = Vector2(size.x, 0)
	$ParallaxBackground/background/Sprite.offset = Vector2(size.x/2,size.y/2)
	#$ParallaxBackground/buttons.margin_right = (size.x*29)/32
	#$ParallaxBackground/buttons.margin_bottom = size.y - 50
	#$ParallaxBackground/buttons.rect_position = Vector2((size.x * 3)/32 , (size.y * 3/4))
	
	

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

