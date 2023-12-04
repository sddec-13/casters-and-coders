extends Node2D

export(String) var puzzle_name

var bridge_lowered = false
var lower_bridge_timeout: float = -1

onready var anim: AnimationPlayer = $AnimationPlayer

func _ready():
	PythonManager.connect("output", self, "_output")
	set_bridge_lowered(false)

func _output(puzzle_name, output_name, args):
	if puzzle_name == self.puzzle_name and output_name == "set_bridge_lowered":
		var lowered = args[0] as bool
		set_bridge_lowered(lowered)
	
func set_bridge_lowered(lowered: bool):
	if lowered != bridge_lowered:
		anim.play("lower" if lowered else "raise")
	bridge_lowered = lowered
