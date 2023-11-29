from godot import exposed
from godot import *
import godot
from typing import List, Dict, Callable
import json


class PuzzleExecution:
	def __init__(self, name: str, source: str, outputs: Dict[str, Callable]):
		self.name = name
		self.context = {**outputs}
		self.code_obj = compile(source, name, "exec")

	def start(self):
		exec(self.code_obj, self.context)

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
		
		context = {"__state__":dict()}
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
			context[output_name] = output_func
			
		for i in definition["input_getters"]:
			input_name = str(i["name"])
			def input_getter(*args):
				# We use self.call, because emit_signal isn't bound right
				# All actual function args are in the list args. Variatics would
				# be nice, but gdscript doesn't support them well.
				# We do have to convert args from a tuple to a list, and then to a godot array
				# I've verified that primitives pass through ok. We might need to explicitly
				# convert more complex objects.
				return context["__state__"][input_name]
			context[input_name] = input_getter
		
		try:
			ex = PuzzleExecution(name, source, context)
			ex.start()
			self.running_puzzles[name] = ex
		except Exception as e:
			print("Failed to start script: ", e)
	
	def unload_puzzle(self, name: str):
		if name not in self.running_puzzles:
			return
		# This pops and deletes both the key (name) and the value (the puzzle)
		del self.running_puzzles[name]
	
	def clear(self):
		self.running_puzzles.clear()
	
	def update_state(self, puzzle_name: str, key: str, val: Any):
		name = str(puzzle_name)
		key = str(key)
		if name not in self.running_puzzles:
			print(f"Tried to set key/val in state to puzzle that is not running: {puzzle_name}")
			return
		execution = self.running_puzzles[name]
		try:
			execution.context["__state__"][key] = value
		except Exception as e:
			print("exception when calling into guest script:")
			print(e)
	
	def set_var(self, puzzle_name: str, var_name: str, value: Any):
		name = str(puzzle_name)
		var_name_name = str(var_name)
		if name not in self.running_puzzles:
			print(f"Tried to give input var to puzzle that is not running: {puzzle_name}")
			return
		execution = self.running_puzzles[name]
		try:
			execution.context[var_name] = value
		except Exception as e:
			print("exception when calling into guest script:")
			print(e)
	
	def run_user_callback(self, puzzle_name: str, callback_name: str, args: list):
		name = str(puzzle_name)
		callback_name = str(calback_name)
		if name not in self.running_puzzles:
			print(f"Tried to give input to puzzle that is not running: {puzzle_name}")
			return
		execution = self.running_puzzles[name]
		if callback_name not in execution.context:
			print("Could not find user callback")
			return
		try:
			execution.context[callback_name](*args)
		except Exception as e:
			print("exception when calling into guest script:")
			print(e)
