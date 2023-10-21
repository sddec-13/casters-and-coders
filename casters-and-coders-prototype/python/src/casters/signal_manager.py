from godot import exposed, export, signal
from godot import *

@exposed
class signal_manager(Node):
	script_started_executing = signal()
	script_finished_executing = signal()
	
	

	def _ready(self):
		"""
		Called every time the node is added to the scene.
		Initialization here.
		"""
		pass
		

	# Handler for the signal sent by GDScript
	# Connection made from the UI but method was not automatically generated.
	# Callback name was printed in the editor console, so just needed
	# to copy/paste it here
	def _on_PlayerCol_event_happened(self) -> None:
		print(f"Event happened: {self.puzzle_definition}")

	@export(dict)
	@property
	def puzzle_definition(self):
		return self._puzzle_def
		
	@puzzle_definition.setter
	def puzzle_definition(self, puzzle_def: dict) -> None:
		"""
		
		"""
		self._puzzle_def = puzzle_def

	def exec_script(self, script_file: str, *args) -> None:
		"""
		Execute a script.
		When calling with signals, an additional argument representing the GDString
		is added, not sure why. To avoid crashing we just add a varargs parameter for
		now, the script name is stil correct
		
		TODO use script objects instead of strings
		TODO investigate threading so we don't block the godot thread, if that's an issue
		
		"""
		print(f"Executing script called {script_file}")
		# Emitting signals is a bit nasty right now
		# https://github.com/touilleMan/godot-python/issues/199#issuecomment-750354045
		
		# Need to make sure the numner of arguments exactly matches the number of arguments
		# for the target method, otherwise an error occurs (only printed in editor
		# output when running through terminal, not in editor output window. Confusing,
		# I know).
		self.call("emit_signal", "script_finished_executing", script_file)
