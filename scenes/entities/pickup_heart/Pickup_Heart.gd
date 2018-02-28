extends Area2D

export (int) var health = 40

func _ready():
	set_process(false)

func be_picked_up(player):
	player.hit(-health)
	queue_free()