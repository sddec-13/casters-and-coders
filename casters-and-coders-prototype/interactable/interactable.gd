extends Area2D
class_name Interactable

signal interacted

func _init():
	collision_layer = 0
	collision_mask = 0
	set_collision_layer_bit(4, true)
