extends Control

export (PackedScene) var Main

func _ready():

	pass




func _on_back_pressed():
	get_tree().change_scene(Main)
	pass # replace with function body
