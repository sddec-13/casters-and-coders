extends PanelContainer


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

onready var text_editor: TextEdit = $VBoxContainer/HSplitContainer/TextEdit
onready var close_button: Button = $VBoxContainer/HBoxContainer/CloseButton
onready var side_panel: VBoxContainer = $VBoxContainer/HSplitContainer/PanelContainer/Methods/VBoxContainer

onready var api_hint_scene = preload("res://interface/code_editor_api_hint.tscn")

var current_puzzle_name = null

const INPUT_COLOR = Color.chartreuse
const OUTPUT_COLOR = Color.magenta

# Called when the node enters the scene tree for the first time.
func _ready():
	close_button.connect("pressed", self, "_close_button_pressed")
	self.hide()

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
	
	populate_side_panel(def)
	configure_editor_colors(def)
	self.show()

func populate_side_panel(def: Dictionary):
	for child in side_panel.get_children():
		side_panel.remove_child(child)
	for input_def in def["inputs"]:
		var api_hint = api_hint_scene.instance()
		api_hint.api_name_color = INPUT_COLOR
		api_hint.api_def = input_def
		side_panel.add_child(api_hint)
	for output_def in def["outputs"]:
		var api_hint = api_hint_scene.instance()
		api_hint.api_name_color = OUTPUT_COLOR
		api_hint.api_def = output_def
		side_panel.add_child(api_hint)

func configure_editor_colors(def: Dictionary):
	text_editor = text_editor as TextEdit
	text_editor.clear_colors()
	for input_def in def["inputs"]:
		var input_name = input_def["name"]
		text_editor.add_keyword_color(input_name, INPUT_COLOR)
	for output_def in def["outputs"]:
		var output_name = output_def["name"]
		text_editor.add_keyword_color(output_name, OUTPUT_COLOR)

func close():
	if current_puzzle_name == null or not self.visible:
		return
	PuzzleLoader.save_source(current_puzzle_name, text_editor.text)
	# Reload the puzzle now that it's been edited
	PythonManager.unload_puzzle(current_puzzle_name)
	PythonManager.load_puzzle(current_puzzle_name)
	self.hide()
	current_puzzle_name = null

func _close_button_pressed():
	self.close()
	

