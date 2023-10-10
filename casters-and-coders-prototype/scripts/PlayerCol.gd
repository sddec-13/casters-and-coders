# This is the player script which contains game logic relating to the player character

extends KinematicBody2D

signal change_room
signal interact_object

var speed = 250
var velocity = Vector2()
var nearby_object : StaticBody2D = null
var collision_info : KinematicCollision2D = null
func get_input():
	# Detect up/down/left/right keystate and only move when pressed.
	velocity = Vector2()

	if Input.is_action_pressed('move_right'):
		velocity.x += 1
	elif Input.is_action_pressed('save'):
		save_game()
	elif Input.is_action_pressed('move_left'):
		velocity.x -= 1
	elif Input.is_action_pressed('move_down'):
		velocity.y += 1
	elif Input.is_action_pressed('move_up'):
		velocity.y -= 1
	elif Input.is_action_pressed("interact"):
		if nearby_object:
			interact_object(nearby_object)
		
	velocity = velocity.normalized() * speed
		
func _physics_process(delta):
	get_input()
	if velocity.x == 0 and velocity.y == 0:
		$AnimatedSprite.animation = "idle"
	elif velocity.x != 0 || velocity.y != 0:
		$AnimatedSprite.animation = "run"
		$AnimatedSprite.flip_h = velocity.x < 0
		
	$AnimatedSprite.play()
	collision_info = move_and_collide(velocity * delta)

func interact_object(object : StaticBody2D):
	match object.object_type:
		"door": # case door
			Global.from_room = get_parent().room_name
			emit_signal("change_room", object.door_to)
		"item": # case item
			emit_signal("interact_object", object)
