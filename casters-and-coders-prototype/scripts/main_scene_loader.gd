extends Node


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
export(String, FILE) var default_scene

# Called when the node enters the scene tree for the first time.
func _ready():
	SceneSwitcher.change_scene(default_scene)
	self.queue_free()


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
