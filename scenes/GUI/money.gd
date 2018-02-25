extends Node2D

var cur_mon
onready var player = get_parent().get_parent().get_node("Player")

func _ready():
	player.money = cur_mon
	change_mon()
	set_process(true)
	pass

func _process(delta):
	if(cur_mon != player.money):
		cur_mon = player.money
		change_mon()

func change_mon():
	$money_text.text = cur_mon
