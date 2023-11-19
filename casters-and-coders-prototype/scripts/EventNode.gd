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

var TutorialRoom3 = [
	# Start off with an empty event, dont do anything
	"", # empty string separates different event stages
	# event stage 1 (spawn key by interacting with locked door)
	"Looks like the door is locked. I see a key in the middle of the room",
	"Let's try using that to unlock the door.",
	"", # empty string separates different event stages
	# event stage 2 (Trigger first 2 layers of the fire booby trap)
	"Oh no, looks like we triggered a trap.",
	"Let's try this spell to get out of this.",
	"", # empty string separates different event stages
	# event stage 3 (Trigger next 2 layers of the fire booby trap)
	"That did not work, we need to try a stronger spell.",
	"", # empty string separates different event stages
	# event stage 4 (Trigger last 2 layers of the fire booby trap)
	"That did not work either. We have one more chance!",
	"", # empty string separates different event stages
	# event stage 5 (Despawn the fire traps and unlock the door)
	"Phew... That was too close!",
	"Let's move on shall we."
]

var event_rooms = {
	"TutorialRoom1" : TutorialRoom1,
	"TutorialRoom2" : TutorialRoom2,
	"TutorialRoom3" : TutorialRoom3,
}

func _ready():
	event_stage = 0	
	var room = get_parent().room_name
	events = event_rooms[room]

func on_Event_Next():
	if event_stage >= events.size(): # end of events
		get_parent().get_node("PopupDialog").event_hide_popup() # stop showing the popup message
		Global.is_event = false # set the global of events false (no active events)
	else:
		if events[event_stage] == "": # if its an empty string, turn event off until it triggers again
			get_parent().get_node("PopupDialog").event_hide_popup() # stop showing the popup message
			Global.is_event = false
		else: # else, continue iterating to next event step
			get_parent().get_node("PopupDialog/Label").text = events[event_stage]
			get_parent().get_node("PopupDialog").event_show_popup()
			event_stage += 1

