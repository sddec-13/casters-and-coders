extends Area2D
class_name Actionable

signal actioned()

func _on_Player_entered(body):
	if body as KinematicBody2D: # if its player
		print("Player entered")
		body.nearby_object = get_parent()

func _on_Player_exited(body):
	if body as KinematicBody2D: # if its player
		print("Player exited")
		body.nearby_object = null
	
