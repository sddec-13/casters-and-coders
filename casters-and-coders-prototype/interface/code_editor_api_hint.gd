extends Control


export(Color) var api_name_color
export(Color) var arg_name_color
export(Dictionary) var api_def

var indent_scene = preload("res://interface/code_editor_indent_block.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
#	print("generating hint for api def: ", api_def)
	var api_name = api_def["name"]
	var description = null
	if "description" in api_def:
		description = api_def["description"]
	var signature = api_def["signature"]
	
	var api_label = label_with_text(api_name + "(" + make_args_string(signature) + ")")
	api_label.modulate = api_name_color
	add_child(api_label)
	var api_indent_contents = VBoxContainer.new()
	
	if description:
		api_indent_contents.add_child(label_with_text(description))
		
	for arg in signature:
		var arg_def = signature[arg]
		var arg_type = ""
		if "type" in arg_def:
			arg_type = arg_def["type"]
		var arg_label = label_with_text(arg + ": " + arg_type)
		arg_label.modulate = arg_name_color
		api_indent_contents.add_child(arg_label)

		if "description" in arg_def:
			var arg_description_text = arg_def["description"]
			api_indent_contents.add_child(with_indent(label_with_text(arg_description_text)))
	
	add_child(with_indent(api_indent_contents))

func label_with_text(text: String):
	var label = Label.new()
	label.autowrap = true
	label.text = text
	return label

func with_indent(content: Control):
	var indent = indent_scene.instance()
	indent.add_content(content)
	return indent

func make_args_string(signature: Dictionary):
	var args_string = ""
	var argc = signature.keys().size()
	for i in argc:
		var arg = signature.keys()[i]
		args_string = args_string + arg
		var arg_def = signature[arg]
		if "type" in arg_def:
			args_string = args_string + ": " + arg_def["type"]
		
		if i + 1 < argc:
			args_string = args_string + ", "
	return args_string

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
