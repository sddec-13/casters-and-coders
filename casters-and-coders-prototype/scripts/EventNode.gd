extends Node

var event_stage # keeps track of event stage
var events # keeps track of the array of events for the room

var TutorialRoom1 = [
	"Welcome to the world of Casters and Coders.... (Spacebar to continue)",
	"In this game, you will be learning how to code....",
	"Good Luck!"
]

var TutorialRoom2 = [
	"Oh no, there seems to be a river blocking the way.",
	"Wait, there is a console over here...",
	"Try interacting with it and see what happens."
]

func _ready():
	event_stage = 0	
	var room = get_parent().room_name
	match room: # set events to a specific array of events based on the room
		"TutorialRoom1":
			events = TutorialRoom1
		"TutorialRoom2":
			events = TutorialRoom2

func on_Event_Next():
	if event_stage >= events.size(): # end of events
		get_parent().get_node("PopupDialog").event_hide_popup() # stop showing the popup message
		Global.is_event = false # set the global of events false (no active events)
	else:
		get_parent().get_node("PopupDialog/Label").text = events[event_stage]
		get_parent().get_node("PopupDialog").event_show_popup()
		event_stage += 1

