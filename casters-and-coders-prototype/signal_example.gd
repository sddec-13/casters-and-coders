extends Node

signal event_happened
signal event_with_args

# Declare member variables here. Examples:
# var a = 2
# var b = "text"


func _ready():
	# Programmatically add signal connection, UI works too
	#self.get_node("Camera2D").connect("script_finished_executing", self, "_on_Camera2D_script_finished_executing")
	
	# Call a method manually, not using signals. Python-side method
	# then emits a signal that is routed back here. Appears to all be done on a single thread
	self.get_node("Pynode").exec_script("test_script.py")
	# Call method using signals
	# unsure if the signal processing is done on a separate thread in GDScript
	emit_signal("event_happened")
	
	# Call exec_script using a signal
	emit_signal("event_with_args", "some_script")


# Handler for the signal sent by Python with arguments,
# handlers with no-args work too
func _on_Pynode_script_finished_executing(script_name):
	print("Finished executing script with name " + script_name) # Replace with function body.
