extends Node2D

# This notation hints the export type to the editor
export(String, FILE) var door_to
export(Vector2) var spawn_pos = Vector2.ZERO
export(bool) var spawn_facing_right = true

onready var interactable = $Interactable

# Called when the node enters the scene tree for the first time.
func _ready():
	interactable.connect("interacted", self, "_interacted")

func _interacted():
	if door_to == null:
		print("Door with no destination: '" + get_path() + "' - set it in the editor!")
		return
	Global.spawn_pos = self.spawn_pos
	Global.spawn_facing_right = spawn_facing_right
	Global.spawn_pos_set = true
	var result = SceneSwitcher.change_scene(door_to)
	# If changing room failed, invalidate the spawn_pos we set
	if result != OK:
		Global.spawn_pos_set = false
