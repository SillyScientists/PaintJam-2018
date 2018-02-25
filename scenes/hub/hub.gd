extends Control

var ran_money


func _ready():
	
	pass

func _process(delta):
	pass


func _on_Button_pressed():
	print("Pressed!")
	get_parent().scene_change()
	print(get_parent().get_path())
	pass # replace with function body
