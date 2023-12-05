extends Node2D


export(String) var puzzle_name

export(int) var rows
export(int) var cols

onready var tilemap: TileMap = $TileMap

# Called when the node enters the scene tree for the first time.
func _ready():
	PythonManager.connect("puzzle_started", self, "_puzzle_started")
	PythonManager.connect("output", self, "_output")
	
	for row in rows:
		for col in cols:
			tilemap.set_cell(col, row, 0)


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func _puzzle_started(puzzle_name):
	if puzzle_name == self.puzzle_name:
		# reset grid
		tilemap.clear()
		for row in rows:
			for col in cols:
				tilemap.set_cell(col, row, 0)
		# fill getter cache
		PythonManager.update_state(self.puzzle_name, "get_rows", rows)
		PythonManager.update_state(self.puzzle_name, "get_cols", cols)
		
		# draw barrier
		for i in rows:
			tilemap.set_cell(0 + i / 4, i, 1)

func _output(puzzle_name, output_name, args):
	print("output: " + output_name)
	if puzzle_name == self.puzzle_name and output_name == "set_pixel":
		var row = args[0]
		var col = args[1]
		var set = args[2]
		if col < 0 or col >= cols:
			Log.push_message("Invalid column: " + col, 1)
			return
		if row < 0 or row >= rows: 
			Log.push_message("Invlid row: " + row, 1)
			return
		tilemap.set_cell(col, row, 1 if set else 0)
