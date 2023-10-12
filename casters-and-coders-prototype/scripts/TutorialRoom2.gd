extends "res://scripts/Room.gd"

func _on_Bridge_Activated(object):
	$PopupDialog.hide()
	$AnimationPlayer.play("quick_event_start") # quick event animation start
	

func _on_AnimationPlayer_animation_finished2(anim_name):
	match anim_name:
		"quick_event_start":
			$Bridge.visible = true # set bridge to visible (activated)
			$Bridge.collision_mask = 2 # set collisions to 2 (not same layer as player)
			$Bridge.collision_layer = 2 # player can now walk through bridge
			$PopupDialog.show_popup(3)
			$AnimationPlayer.play("quick_event_end") # quick event animation end			
