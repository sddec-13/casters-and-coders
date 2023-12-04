extends Node2D

export(String) var puzzle_name
export(int) var lever_number

onready var interactable = $Interactable
onready var a_sprite = $AnimatedSprite

var pulled_right = true


# Called when the node enters the scene tree for the first time.
func _ready():
	interactable.connect("interacted", self, "_interacted")
	pass # Replace with function body.

func _interacted():
	pulled_right = not pulled_right
	a_sprite.frame = 0 if pulled_right else 1
	PythonManager.input(puzzle_name, "lever_pulled", [lever_number, pulled_right])

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
