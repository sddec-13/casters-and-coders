extends Node

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

func save_source(name: String, source: String):
	var f = File.new()
	var path = "user://puzzle_scripts/%s.py" % name
	var err = f.open(path, File.WRITE)
	if err != OK:
		print("Failed to save source for " + path)
		return
	f.store_string(source)
	f.close()
