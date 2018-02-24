extends Camera2D

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

func _ready():
	set_process(true);
	pass

func _process(delta):
	var pos = get_parent().global_position
	pos = Vector2(pos.x + 2,pos.y)
	get_parent().global_position = pos




