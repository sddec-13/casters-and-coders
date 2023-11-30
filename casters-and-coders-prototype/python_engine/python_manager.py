from godot import exposed
from godot import *
import godot
from typing import List, Dict, Callable
import json
import traceback
import sys

class PuzzleExecution:
	def __init__(self, name: str, source: str, outputs: Dict[str, Callable], other_context = {}):
		self.name = name
		self.context = {**outputs, **other_context}
		self.code_obj = compile(source, name, "exec")

	def start(self):
		exec(self.code_obj, self.context)

@exposed
class python_engine(Node):
	
	output = signal()

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
		
		def print_overload(*args):
			for arg in args:
				self.log.push_message(str(arg), 0)
		other_context = {
			"print": print_overload 
		}
		
		try:
			ex = PuzzleExecution(name, source, outputs, other_context)
			print(ex.context)
			ex.start()
			self.running_puzzles[name] = ex
		except Exception as e:
			print("Failed to start script: ", e)
	
	def unload_puzzle(self, name: str):
		if name not in self.running_puzzles:
			return
		# This removes the key from the dict
		self.running_puzzles.pop(name, None)
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
			execution.context[input_name](*args)
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
