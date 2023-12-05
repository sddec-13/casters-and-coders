extends PanelContainer


onready var text_editor: TextEdit = $VBoxContainer/HSplitContainer/TextEdit
onready var close_button: Button = $VBoxContainer/HBoxContainer/CloseButton
onready var hooks_panel: VBoxContainer = $VBoxContainer/HSplitContainer/PanelContainer/ScrollContainer/VBoxContainer/HooksContainer
onready var outputs_panel: VBoxContainer = $VBoxContainer/HSplitContainer/PanelContainer/ScrollContainer/VBoxContainer/OutputsContainer
onready var getters_label: Label = $VBoxContainer/HSplitContainer/PanelContainer/ScrollContainer/VBoxContainer/GettersLabel
onready var getters_panel: VBoxContainer = $VBoxContainer/HSplitContainer/PanelContainer/ScrollContainer/VBoxContainer/GettersContainer
onready var readonly_panel: PanelContainer = $VBoxContainer/HBoxContainer/ReadonlyPanel

onready var api_hint_scene = preload("res://interface/code_editor_api_hint.tscn")

var current_puzzle_name = null

const HOOK_COLOR = Color(.28, .94, .28)
const OUTPUT_COLOR = Color(.78, .41, 1.0)
const GETTER_COLOR = Color(.41, 1.0, .79)
const KEYWORD_COLOR = Color(1.0, .4, .41)
const COMMENT_COLOR = Color(0.7, 0.7, 0.7, 0.7)
const STRING_COLOR = Color(1.0, .93, .41)
const HINT_ARG_NAME_COLOR = Color(1.0, .93, .41)
const KEYWORD_LIST = [
	"def",
	"if",
	"else",
	"and",
	"or",
	"not",
	"global",
	"True",
	"False",
	"in",
	"is",
	"pass",
	"for",
	"while",
	"break",
	"continue",
	"try",
	"except",
	"raise",
	"finally",
]

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
	for child in hooks_panel.get_children():
		hooks_panel.remove_child(child)
	for child in outputs_panel.get_children():
		outputs_panel.remove_child(child)
	for child in getters_panel.get_children():
		getters_panel.remove_child(child)
	
	for hook_def in def["hooks"]:
		var api_hint = api_hint_scene.instance()
		api_hint.api_name_color = HOOK_COLOR
		api_hint.arg_name_color = HINT_ARG_NAME_COLOR
		api_hint.api_def = hook_def
		hooks_panel.add_child(api_hint)
	
	for output_def in def["outputs"]:
		var api_hint = api_hint_scene.instance()
		api_hint.api_name_color = OUTPUT_COLOR
		api_hint.arg_name_color = HINT_ARG_NAME_COLOR
		api_hint.api_def = output_def
		outputs_panel.add_child(api_hint)
		
	if "input_getters" in def:
		getters_label.visible = true
		for getter_def in def["input_getters"]:
			var api_hint = api_hint_scene.instance()
			api_hint.api_name_color = GETTER_COLOR
			api_hint.arg_name_color = HINT_ARG_NAME_COLOR
			api_hint.api_def = getter_def
			getters_panel.add_child(api_hint)
	else:
		getters_label.visible = false

func configure_editor_colors(def: Dictionary):
	text_editor = text_editor as TextEdit
	text_editor.clear_colors()
	text_editor.add_color_region("#", "", COMMENT_COLOR, true)
	text_editor.add_color_region("\"", "\"", STRING_COLOR, false)
	for keyword in KEYWORD_LIST:
		text_editor.add_keyword_color(keyword, KEYWORD_COLOR)
	for hook_def in def["hooks"]:
		var hook_name = hook_def["name"]
		text_editor.add_keyword_color(hook_name, HOOK_COLOR)
	for output_def in def["outputs"]:
		var output_name = output_def["name"]
		text_editor.add_keyword_color(output_name, OUTPUT_COLOR)
	if "input_getters" in def:
		for getter_def in def["input_getters"]:
			var getter_name = getter_def["name"]
			text_editor.add_keyword_color(getter_name, GETTER_COLOR)

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
	

