extends RigidBody2D

export (int) var SPEED = 10000
export (int) var VIEWDISTANCE = 1000

var velocity = Vector2()
onready var player = $"../Player"

const empty_Vec2 = Vector2()

func _ready():
	linear_damp = 1

func _process(delta):
	velocity *= 0
	if (!player):
		return
	
	var target = player
	
	if position.distance_to(target.position) <= VIEWDISTANCE:
		velocity = target.position - position
		
		applied_force *= 0
		add_force(empty_Vec2, velocity.normalized())
		applied_force = applied_force.normalized() * SPEED * delta
		