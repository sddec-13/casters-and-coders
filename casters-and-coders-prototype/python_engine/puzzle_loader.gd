extends Node

func _ready():
	populate_predefined_puzzle_scripts()

func populate_predefined_puzzle_scripts():
	var predefined_puzzle_scripts_path = "res://predefined_puzzle_scripts/"
	# Load up all the predetermined scripts, not overwriting user edits.
	var d = Directory.new()
	if d.open(predefined_puzzle_scripts_path) != OK:
		print("could not open predefined puzzle scripts directory")
		return
	d.list_dir_begin()
	var file_name = d.get_next()
	while file_name != "":
		if not d.current_is_dir():
			# Process each file (file_name is the name of the file)
			var puzzle_name = file_name.rstrip(".py")
			var def = load_definition(puzzle_name)
			# if it's a readonly script, just overwrite always. Why not.
			var overwrite = "readonly" in def and def["readonly"]
			var f = File.new()
			if f.open(predefined_puzzle_scripts_path + file_name, File.READ) != OK:
				print("could not open " + predefined_puzzle_scripts_path + file_name)
			var source = f.get_as_text()
#			print("saving: " + puzzle_name, source)
			save_source(puzzle_name, source, overwrite)
		file_name = d.get_next()
	d.list_dir_end()

func load_definition_string(name: String) -> String:
	var f = File.new()
	var path = "res://puzzle_defs/%s.json" % name
	var err = f.open(path, File.READ)
	if err != OK:
		print("Failed to load definition for " + path)
		return ""
	var text = f.get_as_text()
	f.close()
	return text
	
func load_definition(name: String):
	var def_string = load_definition_string(name)
	var parse = JSON.parse(def_string)
	if parse.error != OK:
		print("error parsing JSON definition for ", name)
		print(parse.error_string, parse.error_line)
		return {}
	return parse.result

func load_source(name: String) -> String:
	var f = File.new()
	var path = "user://puzzle_scripts/%s.py" % name
	# If the file doesn't exist yet, just run an empty file.
	if not f.file_exists(path):
		return ""
	var err = f.open(path, File.READ)
	if err != OK:
		print("Failed to load source for " + path)
		return ""
	var source = f.get_as_text()
	f.close()
	return source

func save_source(name: String, source: String, overwrite = true):
	var f = File.new()
	var path = "user://puzzle_scripts/%s.py" % name
	if not overwrite and f.file_exists(path):
			f.open(path, File.READ)
			# Only avoid overwriting a file if its contents aren't an empty string
			if f.get_as_text() != "":
				f.close()
				return
			f.close()
	var err = f.open(path, File.WRITE)
	if err != OK:
		print("Failed to save source for " + path)
		return
	f.store_string(source)
	f.close()
