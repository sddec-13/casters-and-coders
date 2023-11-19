extends "res://scripts/Room.gd"

var lever

func _on_Bridge_Activated(object):
	lever = object
	$PopupDialog.hide()
	$AnimationPlayer.play("quick_event_start") # quick event animation start
	
func _on_AnimationPlayer_animation_finished2(anim_name): # this function extends the supermethod
														 # `on_Animation_finished` found in
														 #  Room.gd
	match anim_name:
		"quick_event_start": # handle when first part animation for pulling bridge lever ends
			$Bridge.visible = true # set bridge to visible (activated)
			$Bridge.collision_mask = 2 # set collisions to 2 (not same layer as player)
			$Bridge.collision_layer = 2 # player can now walk through bridge
			var item_type = lever.data["type"]
			$PopupDialog.show_popup(lever.item_description[item_type], 3)
			$AnimationPlayer.play("quick_event_end") # quick event animation end			
