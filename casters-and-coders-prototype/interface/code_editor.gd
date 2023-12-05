extends PanelContainer


onready var text_editor: TextEdit = $VBoxContainer/HSplitContainer/TextEdit
onready var close_button: Button = $VBoxContainer/HBoxContainer/CloseButton
onready var side_panel: VBoxContainer = $VBoxContainer/HSplitContainer/PanelContainer/Methods/VBoxContainer
onready var readonly_panel: PanelContainer = $VBoxContainer/HBoxContainer/ReadonlyPanel

onready var api_hint_scene = preload("res://interface/code_editor_api_hint.tscn")

var current_puzzle_name = null

const HOOK_COLOR = Color.chartreuse
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
	
	
	configure_readonly("readonly" in def and def["readonly"])
	populate_side_panel(def)
	configure_editor_colors(def)
	self.show()

func populate_side_panel(def: Dictionary):
	for child in side_panel.get_children():
		side_panel.remove_child(child)
	for hook_def in def["hooks"]:
		var api_hint = api_hint_scene.instance()
		api_hint.api_name_color = HOOK_COLOR
		api_hint.api_def = hook_def
		side_panel.add_child(api_hint)
	for output_def in def["outputs"]:
		var api_hint = api_hint_scene.instance()
		api_hint.api_name_color = OUTPUT_COLOR
		api_hint.api_def = output_def
		side_panel.add_child(api_hint)

func configure_editor_colors(def: Dictionary):
	text_editor = text_editor as TextEdit
	text_editor.clear_colors()
	for hook_def in def["hooks"]:
		var hook_name = hook_def["name"]
		text_editor.add_keyword_color(hook_name, HOOK_COLOR)
	for output_def in def["outputs"]:
		var output_name = output_def["name"]
		text_editor.add_keyword_color(output_name, OUTPUT_COLOR)

func configure_readonly(readonly: bool):
	readonly_panel.visible = readonly
	text_editor.set_readonly(readonly)

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
	

