extends RigidBody2D

export (int) var SPEED = 10000
export (int) var VIEWDISTANCE = 1000
export (int) var DAMAGE = 20

# Health
export (int) var MAXHEALTH = 100
export (int) var health = 100

var velocity = Vector2()
onready var player = $"../Player"

const empty_Vec2 = Vector2()

func _ready():
	linear_damp = 1

func _process(delta):
	velocity *= 0
	if (!player):
		return
	
	var hunters = get_tree().get_nodes_in_group("Hunter")
	if hunters.size() == 0:
		return
	var target = hunters[0]
	var nearest_dist = INF
	for hunter in hunters:
		var temp_dist = global_position.distance_to(hunter.global_position)
		if temp_dist < nearest_dist:
			nearest_dist = temp_dist
			target = hunter
	
	if position.distance_to(target.global_position) <= VIEWDISTANCE:
		velocity = target.global_position - global_position
		
		# Set animation
		if abs(velocity.x) >= abs(velocity.y):
			$AnimatedSprite.animation = "right" # "left" for new sprites
			$AnimatedSprite.flip_v = false
			$AnimatedSprite.flip_h = velocity.x < 0
		elif velocity.y < 0:
			$AnimatedSprite.animation = "up"
		elif velocity.y > 0:
			$AnimatedSprite.animation = "down"
		
		applied_force *= 0
		add_force(empty_Vec2, velocity.normalized())
		applied_force = applied_force.normalized() * SPEED * delta
		

func hit(damage):
	health = clamp(health - damage, 0, MAXHEALTH)
	if health == 0:
		queue_free()

func _on_Area2D_area_entered( area ):
	var node = area.get_parent()
	var node_name = node.get_name()
	
	#if "Hunter" in node_name:
	#	node.hit(DAMAGE)