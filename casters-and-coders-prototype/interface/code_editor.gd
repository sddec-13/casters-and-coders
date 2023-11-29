extends PanelContainer


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

onready var text_editor = $VBoxContainer/HSplitContainer/TextEdit

var current_puzzle_name = null

# Called when the node enters the scene tree for the first time.
func _ready():
	self.hide()
	pass # Replace with function body.

func open(puzzle_name: String):
	if current_puzzle_name != null or self.visible:
		return
	
	var def = PuzzleLoader.load_definition(puzzle_name)
	if def == {}:
		# We don't need to print an error, the Puzzleloader will print one if it's returning {}.
		return
	
	var source = PuzzleLoader.load_source(puzzle_name)
	
	current_puzzle_name = puzzle_name
	text_editor.text = source
	
	self.show()


func close():
	if current_puzzle_name == null or not self.visible:
		return
	PuzzleLoader.save_source(current_puzzle_name, text_editor.text)
	# Reload the puzzle now that it's been edited
	PythonManager.unload_puzzle(current_puzzle_name)
	PythonManager.load_puzzle(current_puzzle_name)
	self.hide()
	current_puzzle_name = null



func _on_CloseButton_pressed():
	self.close()
