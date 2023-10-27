extends Node

var next_room : Node = null

# The current room
onready var current_room = $StartRoom

# The animation player
onready var anim = $AnimationPlayer

# Called when the node enters the scene tree for the first time.
func _ready():
	# connect the `room_changed` signal to the `handle_change_room` function defined below
	current_room.connect("room_changed", self, "handle_change_room")

func handle_change_room(next_room_name: String):
	next_room = load("res://scenes/" + next_room_name + ".tscn").instance()
	for child in next_room.get_children(): # hide all children till animation completes
		child.visible = false
	add_child(next_room)
	anim.play("fade_in")
	next_room.connect("room_changed", self, "handle_change_room") # update signal to be connect to new room

func _on_AnimationPlayer_animation_finished(anim_name: String):
	match anim_name:
		"fade_in":
			current_room.queue_free()
			current_room = next_room
			for child in next_room.get_children(): # display all the children once fade out starts
				child.visible = true
			next_room = null
			anim.play("fade_out")
#		"fade_out":
			
