extends KinematicBody2D

signal event_happened
signal event_with_args
var speed = 250
var velocity = Vector2()

func _ready():
	# Programmatically add signal connection, UI works too
	#self.get_node("Camera2D").connect("script_finished_executing", self, "_on_Camera2D_script_finished_executing")
	
	# Call a method manually, not using signals. Python-side method
	# then emits a signal that is routed back here. Appears to all be done on a single thread
	self.get_node("Camera2D").exec_script("test_script.py")
	# Call method using signals
	# unsure if the signal processing is done on a separate thread in GDScript
	emit_signal("event_happened")
	
	# Call exec_script using a signal
	emit_signal("event_with_args", "some_script")

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

# Handler for the signal sent by Python with arguments,
# handlers with no-args work too
func _on_Camera2D_script_finished_executing(script_name):
	print("Finished executing script with name " + script_name) # Replace with function body.
