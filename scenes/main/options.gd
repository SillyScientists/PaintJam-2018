extends Popup

onready var menu = $graphics_panel/res_menu
onready var popup = menu.get_popup()

var res = [Vector2(1920,1080),Vector2(1600,900),Vector2(1440,900),Vector2(1536,864),Vector2(1280,800),Vector2(1366,768),Vector2(1280,720)]


func _ready():
	
	pass

#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass


func _on_graphics_pressed():
	
	
	for i in res:
		popup.add_item(str(i.x) + "x" + str(i.y))
	
	
	popup.connect("index_pressed", self, "_on_res_item_pressed")
	
	$graphics_panel.show()
	pass # replace with function body

func _on_res_item_pressed(index):
	OS.set_window_size(res[index])
	menu.text = popup.get_item_text(index)
	get_parent().get_parent().size_window()
	