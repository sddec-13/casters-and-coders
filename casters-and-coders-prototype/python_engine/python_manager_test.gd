extends Node

# Called when the node enters the scene tree for the first time.
func _ready():
	PythonManager.connect("output", self, "handle_output")
	
	PythonManager.load_puzzle("test_puzzle")
	
	PythonManager.run_hook("test_puzzle", "button_pressed", [])
	
	print("Dropping all running puzzles")
	PythonManager.clear()
	# This finds nothing and prints a warning
	PythonManager.run_hook("test_puzzle", "button_pressed", [])

func handle_output(name, output_name, args):
	print("Recieved output for puzzle '%s' with name '%s', having %d args" % [name, output_name, len(args)])
	print("args: ", args)

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
