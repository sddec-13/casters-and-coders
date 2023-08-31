extends KinematicBody2D

var speed = 250
var velocity = Vector2()

func get_input():
	# Detect up/down/left/right keystate and only move when pressed.
	velocity = Vector2()
	if Input.is_action_pressed('move_right'):
		velocity.x += 1
	if Input.is_action_pressed('move_left'):
		velocity.x -= 1
	if Input.is_action_pressed('move_down'):
		velocity.y += 1
	if Input.is_action_pressed('move_up'):
		velocity.y -= 1
	velocity = velocity.normalized() * speed
		
func _physics_process(delta):
	get_input()
	if velocity.x == 0 and velocity.y == 0:
		$AnimatedSprite.animation = "idle"
	elif velocity.x != 0 || velocity.y != 0:
		$AnimatedSprite.animation = "run"
		$AnimatedSprite.flip_h = velocity.x < 0
		
	$AnimatedSprite.play()
	
	move_and_slide(velocity)
