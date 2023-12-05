extends Node2D


export var puzzle_name: String
export var input_name: String

onready var interactable = $Interactable

# Called when the node enters the scene tree for the first time.
func _ready():
	interactable.connect("interacted", self, "_interacted")

func _interacted():
	PythonManager.run_hook(puzzle_name, input_name, [])
