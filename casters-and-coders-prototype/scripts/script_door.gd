extends Node2D


export var puzzle_name: String
export var output_name: String

onready var interactable = $Interactable
onready var sprite = $Sprite

# Called when the node enters the scene tree for the first time.
func _ready():
	PythonManager.connect("output", self, "_python_output")
#	interactable.connect("interacted", self, "_interacted")


#func _interacted(open: bool):

func _python_output(puzzle_name, output_name, args):
	if puzzle_name == self.puzzle_name and output_name == self.output_name:
		# if the names match, we can probably expect the output to be in the right format.
		# TODO: give better feedback to the player if something goes amiss here.
		var open: bool = args[0]
		if open:
			sprite.frame = 1
		else:
			sprite.frame = 0
