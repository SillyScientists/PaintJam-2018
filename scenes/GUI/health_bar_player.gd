extends Node2D

var cur_health
onready var player = get_parent().get_parent().get_node("Player")

func _ready():
	cur_health = player.health
	change_health()
	set_process(true)


func _process(delta):
	if(player.health != cur_health):
		cur_health = player.health
		change_health()


func change_health():
	$health.rect_scale = Vector2(cur_health / player.MAXHEALTH , 1)
