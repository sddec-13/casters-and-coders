from godot import exposed
from godot import *
import godot
from typing import List, Dict, Callable, Any
import json
import traceback
import sys


class PuzzleExecution:
	def __init__(self, name: str, source: str, outputs: Dict[str, Callable], inputs: Dict[str, Callable], other_context: Dict[str, Any] = dict()):
		self.name = name
		self.context = {**outputs, **inputs, **other_context}
		try:
			self.code_obj = compile(source, name, "exec")
		except SyntaxError as s:
			# TODO a way to tell the user the script is broken
			print("USER SCRIPT DID NOT COMPILE", file=sys.stderr)
			print(s, file=sys.stderr)


	def start(self):
		try:
			exec(self.code_obj, self.context)
		except Exception as e:
			print(f"User exception caught: {e}")

@exposed
class python_engine(Node):
	
	output = signal()
	puzzle_started = signal()

	puzzle_loader = None
	timer = None
	log = None
	
	running_puzzles: Dict[str, PuzzleExecution] = {}

	def _ready(self):
		self.puzzle_loader = self.get_node("/root/PuzzleLoader")
		self.log = self.get_node("/root/Log")
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
		
		outputs = dict()
		inputs = dict()
		other_context = {"__state__":dict()}
		for o in definition.get("outputs", []):
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
			
		for i in definition.get("input_getters", []):
			input_name = str(i["name"])
			def input_getter(*args):
				if input_name not in self.running_puzzles[name].context["__state__"]:
					return None
				return self.running_puzzles[name].context["__state__"][input_name]
			inputs[input_name] = input_getter
		
		def print_overload(*args):
			# TODO print()'s arguments are usually printed on one
			# line with a separator, by default a space.
			for arg in args:
				self.log.push_message(str(arg), 0)
		other_context.update({
			"print": print_overload
		})
		
		try:
			ex = PuzzleExecution(name, source, outputs, inputs, other_context)
			print(ex.context)
			self.running_puzzles[name] = ex
			ex.start()
			self.call("emit_signal", "puzzle_started", name)

		except Exception as e:
			print("Failed to start script: ", e)
	
	def unload_puzzle(self, name: str):
		if name not in self.running_puzzles:
			return
		# This pops and deletes both the key (name) and the value (the puzzle)
		del self.running_puzzles[name]
	
	def clear(self):
		self.running_puzzles.clear()
	
	def update_state(self, puzzle_name: str, key: str, value: Any):
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
	
	def run_hook(self, puzzle_name: str, hook_name: str, args: list):
		name = str(puzzle_name)
		hook_name = str(hook_name)
		if name not in self.running_puzzles:
			print(f"Tried to give input to puzzle that is not running: {puzzle_name}")
			return
		execution = self.running_puzzles[name]
		if hook_name not in execution.context:
			print("Could not find user hook")
			self.log.push_message(f"Tried to call hook, but couldn't find it: {name}()", 1)
			return
		try:
			execution.context[hook_name](*args)
		except Exception as e:
			print("exception when calling into guest script:")
			print(e)
			
			# This is how you can get a line number, but I'm not sure how to get it for the guest script.
			# It gives the line where the input function is triggered just above.
#			exc_type, exc_obj, exc_tb = sys.exc_info()
#			line_number = exc_tb.tb_lineno
			# Python can't see godot constants, so we have to use this int enum directly.
			# 1 is for red error text
			self.log.push_message(str(e), 1)
