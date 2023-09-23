extends Node

signal room_changed(room_name)

export (String) var room_name = "room"

# The animation player
onready var anim = $AnimationPlayer
var new_room = null

func _ready():
	anim.play("fade_out")
	$Player.set_position(Vector2($SpawnPos.position))
	if self.room_name == "Main" and Global.from_room: # if re-entering main room, spawn based on door
		$Player.set_position(Vector2(get_node("SpawnPos" + Global.from_room).position))
		
func _on_Player_change_room(room_name):
#	emit_signal("room_changed", room_name)
	anim.play("fade_in")
	new_room = room_name

func _on_AnimationPlayer_animation_finished(anim_name):
	match anim_name:
		"fade_in":
			get_tree().change_scene("res://scenes/" + new_room + ".tscn")
			new_room = null

