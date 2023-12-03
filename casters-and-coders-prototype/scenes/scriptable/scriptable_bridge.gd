extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
export(String) var puzzle_name
export(int) var bridge_num

var bridge_lowered = false
var lower_bridge_timeout: float = -1

onready var anim: AnimationPlayer = $AnimationPlayer

func _ready():
	PythonManager.connect("output", self, "_output")
	set_bridge_lowered(false)

func _process(delta):
	if bridge_lowered:
		if lower_bridge_timeout < 0:
			set_bridge_lowered(false)
		else:
			lower_bridge_timeout -= delta


func _output(puzzle_name, output_name, args):
	if puzzle_name == self.puzzle_name and output_name == "lower_bridge":
		if args[0] == self.bridge_num:
			set_bridge_lowered(true)
	
func set_bridge_lowered(lowered: bool):
	if lowered != bridge_lowered:
		anim.play("lower" if lowered else "raise")
	bridge_lowered = lowered
	lower_bridge_timeout = 3
