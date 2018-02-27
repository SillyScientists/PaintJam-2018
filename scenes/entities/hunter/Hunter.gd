extends RigidBody2D
signal hit_player

export (int) var SPEED = 10000
export (int) var VIEWDISTANCE = 1000
export (int) var DAMAGE = 25

# Health
export (int) var MAXHEALTH = 100
var health = 100

var attackers = []

var velocity = Vector2()
var frozen = false
onready var player = $"../Player"
var zombie_scene = load("res://scenes//entities//zombie//Zombie.tscn")


const empty_Vec2 = Vector2()


func full_heal():
	health = MAXHEALTH

func _ready():
	set_process(true)
	full_heal()
	linear_damp = 1
	$AnimatedSprite.play()

func add_attacker(attacker):
	if !(attacker in attackers):
		attackers.append(attacker)

func remove_attacker(attacker):
	attackers.remove(attackers.find(attacker))

func hit(damage):
	health = clamp(health - damage, 0, MAXHEALTH)
	
	if health == 0:
		die()

func die():
	if player in attackers:
		create_zombie()
		player.stop_sucking()
	queue_free()

func create_zombie():
	var new_zombie = zombie_scene.instance()

	new_zombie.MAXHEALTH = MAXHEALTH
	new_zombie.health = health
	new_zombie.DAMAGE = DAMAGE
	new_zombie.global_position = global_position
	get_parent().add_child( new_zombie )

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
	
	if frozen:
		linear_velocity *= 0
		return
	
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

func freeze(start):
	frozen = start
	if frozen:
		$AnimatedSprite.animation = "default"
		$AnimatedSprite.stop()
		return
	$AnimatedSprite.play()

func _on_Area2D_area_entered( area ):
	var node = area.get_parent()
	if node.is_in_group("Zombie"):
		add_attacker(node)

func _on_Area2D_area_exited( area ):
	var node = area.get_parent()
	if node in attackers:
		remove_attacker(node)
