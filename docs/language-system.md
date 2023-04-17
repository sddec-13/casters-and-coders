## Language Embedding System

The Language Embedding System (LMS) is a subsystem of our project which will handle the execution of player-written python scripts. It will expose some APIs so that scripts can interact with the outside world.


### Structure

The LMS is exposed to the wider Godot ecosystem as a Node, which can interact with other Nodes.

It exposes some functions and responds to some signals.

### Functionality

- `addAPI(name, callback)` takes a function, and exposes it to any internal python script by the given name 
- `addProperty(name, callback)` exposes a property to the internal script. This property should be readonly and will evaluate to the value of the callback when accessed.
- `addTest(name, callback, expected)` similar to addAPI, this callback can be run against the function as a test, and expects the given value.
- `setScript(text)` takes a script to be executed.
- `execute(...)` takes any parameters which the set script might expect, and returns any output from it.
- `clear()` resets the Node to default values.

