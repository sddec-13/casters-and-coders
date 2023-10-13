extends "res://scripts/EventNode.gd"

var events = [
	"Oh no , there is a river blocking my way!!",
	"Wait, there is a console over here",
	"Try interact with it, see what's going to happen"
]

var event_stage # keeps track of event stage

func _ready():
	event_stage = 0	

func on_Event_Next():
	if event_stage >= events.size(): # end of events
		get_parent().get_node("PopupDialog").event_hide_popup() # stop showing the popup message
		Global.is_event = false # set the global of events false (no active events)
	else:
		get_parent().get_node("PopupDialog/Label").text = events[event_stage]
		get_parent().get_node("PopupDialog").event_show_popup()
		event_stage += 1
