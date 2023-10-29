from typing import Any, Callable, Dict
from enum import Enum

InterfaceType = Enum("InterfaceType", ["VAR_DEF", "FUN_DEF"])

class ApiGenerator():
	
	def __init__(self, puzzle_def: Dict[str, Any]):
		self.puzzle_def = puzzle_def
		
	
	def gen_input_var(self, manager, name: str, signal: str) -> Callable[[], Any]:
		# TODO this is just a placeholder for now, we actually want to
		# automatically connect the signal to a function that sets the
		# variable
		def input_var():
			return manager.inputs[name]
			
		return input_var
	
	def gen_input(self, manager, script_input: Dict[str, Any]) -> Any:
		if InterfaceType[str(script_input["type"])] == InterfaceType.VAR_DEF:
			return self.gen_input_var(manager, str(script_input["name"]), str(script_input["signal"]))
	
	def generate_api(self, manager) -> Dict[str, Any]:
		api = dict()
		api["__name__"] = str(self.puzzle_def["name"])
		for script_input in self.puzzle_def["inputs"]:
			api[str(script_input["name"])] = self.gen_input(manager, script_input)
		return api
