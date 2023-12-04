extends Node
# Main room script

signal room_changed(room_name)

export (String) var room_name = "room"

var new_room = null

func _ready():
	if $Player:
		$Player.set_position(Vector2($SpawnPos.position))
		if self.room_name == "Main" and Global.from_room: # if entering main room, spawn based on door
			$Player.set_position(Vector2(get_node("SpawnPos" + Global.from_room).position))
