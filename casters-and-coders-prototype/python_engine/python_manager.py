from godot import exposed
from godot import *
import godot
from typing import List, Dict, Callable
import json


class PuzzleExecution:
	def __init__(self, name: str, source: str, outputs: Dict[str, Callable]):
		self.name = name
		self.global_context = {**outputs}
		self.local_context = {}
		self.code_obj = compile(source, name, "exec")
	
	def start(self):
		# Any output functions should be in the glabal context so they can be called anywhere.
		# Input functions should be in local context so they are available when defined in the
		# root scope without needing a global keyword like "global def foo()".
		# It's worth noting that if we build in sync'd variables, they should be in the global context.
		exec(self.code_obj, self.global_context, self.local_context)

@exposed
class python_engine(Node):
	
	output = signal()

	puzzle_loader = None
	timer = None
	
	running_puzzles: Dict[str, PuzzleExecution] = {}

	def _ready(self):
		self.puzzle_loader = self.get_node("/root/PuzzleLoader")
		self.timer = self.get_node("Timer")
		
	def load_puzzle(self, name: str):
		name = str(name)
		if name in self.running_puzzles:
			self.unload_puzzle(name)
		definition = str(self.puzzle_loader.load_definition_string(name))
		definition = json.loads(definition)
		source = str(self.puzzle_loader.load_source(name))
		
#		print("loaded source " + str(source))
#		print("loaded def" + str(definition))
		
		if definition is None or source is None:
			return
		
		outputs = {}
		for o in definition["outputs"]:
			output_name = str(o["name"])
			def output_func(*args):
				# We use self.call, because emit_signal isn't bound right
				# All actual function args are in the list args. Variatics would
				# be nice, but gdscript doesn't support them well.
				# We do have to convert args from a tuple to a list, and then to a godot array
				# I've verified that primitives pass through ok. We might need to explicitly
				# convert more complex objects.
				self.call("emit_signal", "output", name, output_name, godot.Array(list(args))) 
			outputs[output_name] = output_func
		
		ex = PuzzleExecution(name, source, outputs)
		ex.start()
		self.running_puzzles[name] = ex
	
	def unload_puzzle(self, name: str):
		if name not in running_puzzles:
			return
		# This removes the key from the dict
		running_puzzles.pop(name, None)
		# This method may seem simplistic, but if we ensure that running_puzzles
		# holds the only reference to this puzzle's execution context, the GC
		# will eat it as soon as the reference is dropped.
	
	def clear(self):
		self.running_puzzles.clear()
	
	def input(self, puzzle_name: str, input_name: str, args: list):
		name = str(puzzle_name)
		input_name = str(input_name)
		if name not in self.running_puzzles:
			print(f"Tried to give input to puzzle that is not running: {puzzle_name}")
			return
		execution = self.running_puzzles[name]
		try:
			# remember that input functions should be in local context
			execution.local_context[input_name](*args)
		except Exception as e:
			print("exception when calling into guest script:")
			print(e)
		
