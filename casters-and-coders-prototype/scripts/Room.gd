extends Node
# Main room script

signal room_changed(room_name)

export (String) var room_name = "room"

# The animation player
onready var anim = $AnimationPlayer
var new_room = null

func _ready():
	anim.play("fade_out")
	
	Global.is_event = true # set event to true on load
	if $EventNode: # if event node exists
		$EventNode.on_Event_Next() # start event
	else: # event node does not exist (no events on this scene)
		Global.is_event = false # update event to false
	
	if $Player:
		$Player.set_position(Vector2($SpawnPos.position))
		if self.room_name == "Main" and Global.from_room: # if entering main room, spawn based on door
			$Player.set_position(Vector2(get_node("SpawnPos" + Global.from_room).position))
		
func _on_Player_change_room(room_name):
#	emit_signal("room_changed", room_name)
	anim.play("fade_in")
	new_room = room_name

func _on_AnimationPlayer_animation_finished(anim_name):
	match anim_name:
		"fade_in": # fade in just finished
			get_tree().change_scene("res://scenes/Rooms/" + new_room + ".tscn") # change the scene
			new_room = null

func _on_Player_interact_object(object):
	var item_type = object.data["type"]
	print(object.item_description[item_type]) # prints the object description
	$PopupDialog.show_popup(object.item_description[item_type], 3)
	
