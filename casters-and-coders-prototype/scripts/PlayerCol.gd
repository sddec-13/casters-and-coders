# This is the player script which contains game logic relating to the player character

extends KinematicBody2D

signal change_room

var speed = 250
var velocity = Vector2()
var next_door = false # track the state whether player is next to door or not

func get_input():
	# Detect up/down/left/right keystate and only move when pressed.
	velocity = Vector2()

	if Input.is_action_pressed('move_right'):
		velocity.x += 1
	elif Input.is_action_pressed('move_left'):
		velocity.x -= 1
	elif Input.is_action_pressed('move_down'):
		velocity.y += 1
	elif Input.is_action_pressed('move_up'):
		velocity.y -= 1
	elif Input.is_action_just_pressed("interact"):
		if next_door:
			print("Transitioning room...")
			emit_signal("change_room")
	
	velocity = velocity.normalized() * speed
		
func _physics_process(delta):
	get_input()
	if velocity.x == 0 and velocity.y == 0:
		$AnimatedSprite.animation = "idle"
	elif velocity.x != 0 || velocity.y != 0:
		$AnimatedSprite.animation = "run"
		$AnimatedSprite.flip_h = velocity.x < 0
		
	$AnimatedSprite.play()
	var move_info = move_and_collide(velocity * delta)

func transition_scene(room):
	print(room)

func _on_Door_body_entered(body):
	if body.is_in_group("player"):
		print("Player ENTERED door!")
		next_door = true


func _on_Door_body_exited(body):
	if body.is_in_group("player"):
		print("Player EXITED door!")
		next_door = false
