from typing import Any, Callable, Dict
from enum import Enum

InterfaceType = Enum("InterfaceType", ["VAR_DEF", "FUN_DEF"])

class ApiGenerator():
	
	def __init__(self, puzzle_def: Dict[str, Any]):
		self.puzzle_def = puzzle_def
		
	
	def gen_input_var(self, manager, name: str, node: str, signal: str) -> Any:

		def set_input_var(env: dict, value, *args):
			print(f"Setting var {name} to {value}")
			env[name] = value
			
		manager.add_handler(node, signal, set_input_var)
		return None
		
	def gen_input_fun(self, manager, name: str, node: str, signal: str) -> Any:

		def update_input_var(env: dict, value, *args):
			print(f"Updating internal var {name} to {value}")
			manager.inputs[name] = value
		
		def get_input_val() -> Any:
			return manager.inputs[name]	
		
		manager.add_handler(node, signal, update_input_var)
		return get_input_val
		
	def gen_output_fun(self, manager, name: str, node: str, signal: str) -> Any:
		
		def call_output_fun(*args, **kwargs):
			manager.call("emit_signal", signal, *args, kwargs)
		
		manager.connect_to_signal(node, signal, call_output_fun)
		return call_output_fun
		
	def gen_output_var(self, manager, name: str, node: str, signal: str) -> Any:
			
		manager.output_vars[name] = (node, signal)
		return None
	
	def gen_input(self, manager, script_input: Dict[str, Any]) -> Any:
		if InterfaceType[str(script_input["type"])] == InterfaceType.VAR_DEF:
			return self.gen_input_var(
				manager,
				str(script_input["name"]),
				str(script_input["node"]),
				str(script_input["signal"])
			)
			
		elif InterfaceType[str(script_input["type"])] == InterfaceType.FUN_DEF:
			return self.gen_input_fun(
				manager,
				str(script_input["name"]),
				str(script_input["node"]),
				str(script_input["signal"])
			)
			
	def gen_output(self, manager, script_output: Dict[str, Any]) -> Any:
		if InterfaceType[str(script_output["type"])] == InterfaceType.VAR_DEF:
			return self.gen_output_var(
				manager,
				str(script_input["name"]),
				str(script_input["node"]),
				str(script_input["signal"])
			)
			
		elif InterfaceType[str(script_output["type"])] == InterfaceType.FUN_DEF:
			return self.gen_output_fun(
				manager,
				str(script_input["name"]),
				str(script_input["node"]),
				str(script_input["signal"])
			)
	
	def generate_api(self, manager) -> Dict[str, Any]:
		api = dict()
		api["__name__"] = str(self.puzzle_def["name"])
		for script_input in self.puzzle_def["inputs"]:
			api[str(script_input["name"])] = self.gen_input(manager, script_input)
			
		for script_output in self.puzzle_def["outputs"]:
			api[str(script_output["name"])] = self.gen_output(manager, script_output)
		return api
