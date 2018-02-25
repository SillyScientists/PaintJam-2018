extends Node2D

var zombies  

func _ready():
	zombies = get_tree().get_nodes_in_group("Zombie")
	change_zom()
	set_process(true)
	

func _process(delta):
	if(zombies.size() != get_tree().get_nodes_in_group("Zombie").size()):
		zombies = get_tree().get_nodes_in_group("Zombie")
		change_zom()
	

func change_zom():
	$zombie_text.text = str(zombies.size())