extends "res://scripts/EventNode.gd"

var events = [
	"Welcome to the world of Casters and Coders.... (Spacebar to continue)",
	"In this game, you will be learning how to code....",
	"Good Luck!"
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
