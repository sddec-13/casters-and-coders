extends Node

export (String) var room_name = "room"

signal room_changed(room_name)

func _on_Player_change_room():
	emit_signal("room_changed", room_name)
