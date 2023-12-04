# This is the player script which contains game logic relating to the player character
extends KinematicBody2D

signal change_room
signal interact_object
signal door_locked

var speed = 200
var velocity = Vector2()
var nearby_object : StaticBody2D = null
var collision_info : KinematicCollision2D = null

onready var interactable_finder = $InteractableFinder
var nearest_interactable: Area2D = null

func _ready():
	if Global.spawn_pos_set:
		self.position = Global.spawn_pos
		print(Global.spawn_facing_right)
		$AnimatedSprite.flip_h = not Global.spawn_facing_right

func get_input():
	# Don't process input if a menu is open
	if MenuManager.is_some_menu_open():
		return
	# Detect up/down/left/right keystate and only move when pressed.
	velocity = Vector2()

#	if Global.is_event: # currently an event, cant move
#		if Input.is_action_just_pressed("interact"): # when its an event,
#			get_parent().get_node("EventNode").on_Event_Next() # spacebar to move on to next message
		
	if Input.is_action_pressed('move_right'):
		velocity.x += 1
	if Input.is_action_pressed('move_left'):
		velocity.x -= 1
	if Input.is_action_pressed('move_down'):
		velocity.y += 1
	if Input.is_action_pressed('move_up'):
		velocity.y -= 1

	
	if Input.is_action_just_pressed("interact"):
		print("nearest interactable: ", nearest_interactable)
		if nearest_interactable and nearest_interactable.has_signal("interacted"):
			nearest_interactable.emit_signal("interacted")
	
	velocity = velocity.normalized() * speed

func _physics_process(delta):
	get_input()
	if velocity.x == 0 and velocity.y == 0:
		$AnimatedSprite.animation = "idle"
	elif velocity.x != 0 || velocity.y != 0:
		$AnimatedSprite.animation = "run"
	
	if velocity.x != 0:
		$AnimatedSprite.flip_h = velocity.x < 0
		
	$AnimatedSprite.play()
	collision_info = move_and_collide(velocity * delta)
	
	self.nearest_interactable = get_nearest_interactable()

func interact_object(object : StaticBody2D):
	match object.object_type:
		"door": # case door
			Global.from_room = get_parent().room_name
			emit_signal("change_room", object.door_to)
		"door_locked": # case locked door
			emit_signal("door_locked")
		"item": # case item
			emit_signal("interact_object", object)

func get_nearest_interactable():
	var interactable_areas: Array = interactable_finder.get_overlapping_areas()
	if interactable_areas.empty():
		return null
	var shortest_distance = INF
	# Some cheeky shadowing. This doesn't alter the script's root state.
	var nearest_interactable = null
	for area in interactable_areas:
		area = area as Area2D
		var dist = area.global_position.distance_to(interactable_finder.global_position)
		if dist < shortest_distance:
			shortest_distance = dist
			nearest_interactable = area
	return nearest_interactable
