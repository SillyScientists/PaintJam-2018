extends RigidBody2D

# Movement
export (int) var SPEED = 1000
var velocity = Vector2()
# onready var screensize = get_viewport_rect().size

# Health
export (int) var MAXHEALTH = 400
export (int) var health = 400

var attackers = []

const empty_Vec2 = Vector2()

# Attack
var till_next_attack = 0
var is_attacking = false
export (float) var attack_duration = 0.05
export (float) var attack_timeout = 1

func _ready():
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

func _process(delta):
	# Update attack delay
	if till_next_attack > 0:
		till_next_attack -= delta
	else:
		is_attacking = false
	
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
		# return
	
	# Set animation
	if velocity.x != 0:
		$AnimatedSprite.animation = "right" # "left" for new sprites
		$AnimatedSprite.flip_v = false
		$AnimatedSprite.flip_h = velocity.x < 0
	elif velocity.y < 0:
		$AnimatedSprite.animation = "up"
	elif velocity.y > 0:
		$AnimatedSprite.animation = "down"
	
	# Apply force
	# position += velocity * delta
	applied_force *= 0
	add_force(empty_Vec2, velocity.normalized())
	applied_force = applied_force.normalized() * next_speed * delta
	
	# get damage
	for attacker in attackers:
		hit(attacker.DAMAGE * delta)



func _on_Area2D_area_entered( area ):
	var node = area.get_parent()
	if node.is_in_group("Hunter"):
		add_attacker(node)

func _on_Area2D_area_exited( area ):
	var node = area.get_parent()
	if node in attackers:
		attackers.remove(attackers.find(node))
