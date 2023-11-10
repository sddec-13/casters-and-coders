extends "res://scripts/Room.gd"

export (String) var object_type = "item"
export var object_data = {}

func _ready():
	# disable key visible and collision property
	$Key.visible = false
	$Key.get_node("CollidingArea").disabled = true
	$Key.get_node("Actionable/ActionableArea").disabled = true		
	
func _on_Player_door_locked(): # player attempts to open unlocked door 
	print("DOOR IS LOCKED")
	if $EventNode.event_stage == 0: # first time attempt
		$Key.visible = true # set key to visible and enable collision
		$Key.get_node("CollidingArea").disabled = false
		$Key.get_node("Actionable/ActionableArea").disabled = false
		$Key.collision_mask = 1
		$Key.collision_layer = 1
		# Activate next stage of events
		Global.is_event = true
		$EventNode.event_stage += 1
		$EventNode.on_Event_Next()
	else:
		$PopupDialog.show_popup("Door is locked.", 3)
		
func _on_Key_pickup(key):
	print("PICKED KEY UP!")
	# TODO: implement (disable key visible and collision property)
#	key.visible = false
#	key.get_node("CollidingArea").disabled = true
#	key.get_node("Actionable/ActionableArea").disabled = true
	if $FireLayer1.visible == false:
		print("FOO")
		# Activate next stage of events
		Global.is_event = true
		$EventNode.event_stage += 1
		$EventNode.on_Event_Next()
		triggerFireWall1()
	elif $FireLayer1.visible  == true and $FireLayer3.visible == false:
		print("BAR")
		# Activate next stage of events
		Global.is_event = true
		$EventNode.event_stage += 1
		$EventNode.on_Event_Next()
		triggerFireWall2()
	elif $FireLayer3.visible == true and $FireLayer5.visible == false:
		print("FOOBAR")
		# Activate next stage of events
		Global.is_event = true
		$EventNode.event_stage += 1
		$EventNode.on_Event_Next()
		triggerFireWall3()
	elif $FireLayer5.visible == true:
		print("BARFOO")		
		# Activate next stage of events
		Global.is_event = true
		$EventNode.event_stage += 1
		$EventNode.on_Event_Next()
		fireTrapEnd()
	
func triggerFireWall1():
	# Display fire wall layers 1 and 2
	$FireLayer1.visible = true
	$FireLayer2.visible = true
	
func triggerFireWall2():
	# Display fire walls layers 3 and 4
	$FireLayer3.visible = true
	$FireLayer4.visible = true
	
func triggerFireWall3():
	# Display fire walls layers 5 and 6
	$FireLayer5.visible = true
	$FireLayer6.visible = true
	
func fireTrapEnd():
	# TODO: remove function (disable key visible and collision property)
	$Key.visible = false
	$Key.get_node("CollidingArea").disabled = true
	$Key.get_node("Actionable/ActionableArea").disabled = true
	
	$FireLayer1.visible = false
	$FireLayer2.visible = false
	$FireLayer3.visible = false
	$FireLayer4.visible = false
	$FireLayer5.visible = false
	$FireLayer6.visible = false
	
