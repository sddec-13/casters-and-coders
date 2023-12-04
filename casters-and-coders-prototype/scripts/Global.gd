extends Node2D

# This scene defines the global variables and utility that will be accessed by all scenes

var from_room # Room which player is entering from

var spawn_pos : Vector2 = Vector2.ZERO # spawn position of player upon scene load
var spawn_facing_right: bool = true # if false, the player should spawn with sprite flipped.
var spawn_pos_set: bool = false # should the spawn pos be used? Used for nulling.

var is_event = true # variable to keep track when its currently an event and user has to interact to get
					# continue system messages
