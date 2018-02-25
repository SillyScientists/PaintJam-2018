extends RigidBody2D

export (int) var money = 0

# Movement
export (int) var SPEED = 1000
var velocity = Vector2()

# Health
export (int) var MAXHEALTH = 100
var health = INF

export (int) var DAMAGE = 40

var attackers = []

const empty_Vec2 = Vector2()

# Attack
var till_next_attack = 0
export (float) var attack_duration = 0.05
export (float) var attack_timeout = 1
var is_attacking = false

var is_sucking = false
var sucknode = null


func full_heal():
	health = MAXHEALTH

func _ready():
	full_heal()
	set_process(true)
	linear_damp = 6

func add_attacker(attacker):
	if !(attacker in attackers):
		attackers.append(attacker)

func attack():
	if till_next_attack > 0:
		return false
	till_next_attack = attack_timeout + attack_duration
	is_attacking = true
	return true

func hit(damage):
	if is_attacking:
		return
	health = clamp(health - damage, 0, MAXHEALTH)
	if health == 0:
		die()

func die():
	print("Player died")

func _process(delta):
	# Update attack delay
	if till_next_attack > 0:
		till_next_attack -= delta
	else:
		is_attacking = false
	
	if !Input.is_action_pressed("ui_select"):
		if is_attacking:
			is_attacking = false
		elif is_sucking:
			stop_sucking()
	
	if is_sucking:
		linear_velocity *= 0
		applied_force *= 0
		return
	
	# get user input
	velocity *= 0
	if Input.is_action_pressed("ui_right"):
		velocity.x += 1
	if Input.is_action_pressed("ui_left"):
		velocity.x -= 1
	if Input.is_action_pressed("ui_down"):
		velocity.y += 1
	if Input.is_action_pressed("ui_up"):
		velocity.y -= 1
	if Input.is_action_just_pressed("ui_select"):
		attack()
	
	var next_speed = SPEED
	if till_next_attack - attack_timeout > 0:
		next_speed *= 10
	
	if velocity.length() > 0:
		velocity = velocity.normalized()
		$AnimatedSprite.play()
	else:
		$AnimatedSprite.animation = "default"
		$AnimatedSprite.stop()
	
	# Set animation
	if velocity.x != 0:
		$AnimatedSprite.animation = "right"
		$AnimatedSprite.flip_v = false
		$AnimatedSprite.flip_h = velocity.x < 0
	elif velocity.y < 0:
		$AnimatedSprite.animation = "up"
	elif velocity.y > 0:
		$AnimatedSprite.animation = "down"
	
	# Apply force
	applied_force *= 0
	add_force(empty_Vec2, velocity.normalized())
	applied_force = applied_force.normalized() * next_speed * delta
	
	# get damage
	for attacker in attackers:
		hit(attacker.DAMAGE * delta)

func start_sucking(node):
	is_sucking = true
	is_attacking = false
	
	sucknode = node
	sucknode.freeze(true)
	sucknode.add_attacker(self)
	
	# Set animation
	var suck_dir = sucknode.global_position - global_position
	if abs(suck_dir.x) >= abs(suck_dir.y):
		$AnimatedSprite.animation = "right_sucking"
		$AnimatedSprite.flip_v = false
		$AnimatedSprite.flip_h = suck_dir.x < 0
	elif suck_dir.y < 0:
		$AnimatedSprite.animation = "up_sucking"
	elif suck_dir.y > 0:
		$AnimatedSprite.animation = "down_sucking"
	mass = 1000

func stop_sucking():
	is_sucking = false
	if sucknode != null && sucknode.is_inside_tree():
		sucknode.freeze(false)
		sucknode.remove_attacker(self)
		sucknode = null
	mass = 0.01

func _on_Area2D_area_entered( area ):
	var node = area.get_parent()
	if node.is_in_group("Hunter"):
		if is_attacking && !is_sucking:
			start_sucking(node)
		else:
			add_attacker(node)

func _on_Area2D_area_exited( area ):
	var node = area.get_parent()
	if node in attackers:
		attackers.remove(attackers.find(node))
