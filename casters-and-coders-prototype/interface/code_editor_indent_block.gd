extends HBoxContainer

onready var content_container = $Content

func add_content(content: Control):
	var content_container = get_node("Content")
	for child in content_container.get_children():
		content_container.remove_child(child)
	content_container.add_child(content)
