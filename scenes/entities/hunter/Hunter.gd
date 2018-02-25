extends RigidBody2D
signal hit_player

export (int) var SPEED = 10000
export (int) var VIEWDISTANCE = 1000
export (int) var DAMAGE = 25

# Health
export (int) var MAXHEALTH = 100
export (int) var health = 100

var attackers = []

var velocity = Vector2()
onready var player = $"../Player"


const empty_Vec2 = Vector2()

func _ready():
	linear_damp = 1
	$AnimatedSprite.play()

func add_attacker(attacker):
	if !(attacker in attackers):
		attackers.append(attacker)

func hit(damage):
	health = clamp(health - damage, 0, MAXHEALTH)
	
	if health == 0:
		queue_free()

func _process(delta):
	velocity *= 0
	applied_force *= 0
	if (!player):
		print("ERROR no player found")
		return
	
	# get damage
	for attacker in attackers:
		hit(attacker.DAMAGE * delta)
	
	var zombies = get_tree().get_nodes_in_group("Zombie")
	var target = player
	var nearest_dist = global_position.distance_to(player.global_position) - 120
	for zombie in zombies:
		var temp_dist = global_position.distance_to(zombie.global_position)
		if temp_dist < nearest_dist:
			nearest_dist = temp_dist
			target = zombie
	
	if nearest_dist <= VIEWDISTANCE:
		velocity = target.global_position - global_position
		
		# Set animation
		if abs(velocity.x) >= abs(velocity.y):
			$AnimatedSprite.animation = "right"
			$AnimatedSprite.flip_v = false
			$AnimatedSprite.flip_h = velocity.x < 0
		elif velocity.y < 0:
			$AnimatedSprite.animation = "up"
		elif velocity.y > 0:
			$AnimatedSprite.animation = "down"
		
			
		add_force(empty_Vec2, velocity.normalized())
		applied_force = applied_force.normalized() * SPEED * delta


func _on_Area2D_area_entered( area ):
	var node = area.get_parent()
	if node.is_in_group("Zombie"):
		add_attacker(node)

func _on_Area2D_area_exited( area ):
	var node = area.get_parent()
	if node in attackers:
		attackers.remove(attackers.find(node))
