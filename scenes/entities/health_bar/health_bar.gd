extends Node2D

var cur_health
 

func _ready():
	cur_health = get_parent().health
	change_health()
	set_process(true)
	pass

func _process(delta):
	if(get_parent().health != cur_health):
		cur_health = get_parent().health
		change_health()
	pass

func change_health():
	$health.rect_scale = Vector2(cur_health / get_parent().MAXHEALTH , 1)
	
	if(cur_health == get_parent().MAXHEALTH):
		self.hide()
	else:
		self.show()