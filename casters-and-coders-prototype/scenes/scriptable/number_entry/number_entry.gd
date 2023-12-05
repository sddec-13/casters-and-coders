extends Node2D

onready var console_1 = $NumberEntryConsole
onready var console_2 = $NumberEntryConsole2
onready var console_3 = $NumberEntryConsole3

export(String) var puzzle_name

# Called when the node enters the scene tree for the first time.
func _ready():
	console_1.connect("number_changed", self, "_number_changed")
	console_2.connect("number_changed", self, "_number_changed")
	console_3.connect("number_changed", self, "_number_changed")


func _number_changed(n):
	PythonManager.run_hook(puzzle_name, "numbers_changed", [console_1.number, console_2.number, console_3.number])
