extends CanvasLayer



onready var code_editor = $CodeEditor

# This is read to check if any menu is open
func is_some_menu_open():
	return code_editor.visible


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func open_code_editor(puzzle_name: String):
	code_editor.open(puzzle_name)

