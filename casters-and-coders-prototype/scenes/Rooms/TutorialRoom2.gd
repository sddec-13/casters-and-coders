extends "res://scripts/Room.gd"


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func _on_Bridge_Activated(object):
	print(object)
	$Bridge.visible = true
	$Bridge.collision_mask = 2
	$Bridge.collision_layer = 2
	pass # Replace with function body.
