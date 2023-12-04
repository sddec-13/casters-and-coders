extends Node2D

export var puzzle_name: String
onready var interactable = $Interactable

# Called when the node enters the scene tree for the first time.
func _ready():
	interactable.connect("interacted", self, "_interacted")
	PythonManager.load_puzzle(puzzle_name)

func _interacted():
	PythonManager.clear()
	MenuManager.open_code_editor(puzzle_name)

