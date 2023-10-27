extends Node2D

# This scene defines the global variables and utility that will be accessed by all scenes

var from_room # Room which player is entering from
var spawn_pos : Vector2 = Vector2(509, 305) # initial spawn position of player
var is_event = true # variable to keep track when its currently an event and user has to interact to get
					# continue system messages
