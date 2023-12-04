extends Label


export(int) var type
export(float) var timeout = 5
export(float) var fadeout_duration = 3

signal vanished()

onready var timer = Timer.new()
onready var tween = Tween.new()

# Called when the node enters the scene tree for the first time.
func _ready():
	match type:
		Log.MSG_INFO:
			modulate = Color.white
		Log.MSG_ERR:
			modulate = Color.red
	
	add_child(timer)
	add_child(tween)
	
	timer.start(timeout)
	yield(timer, "timeout")
	tween.interpolate_property(
		self, "modulate:a",
		1, 0,
		fadeout_duration,
		Tween.TRANS_LINEAR, Tween.EASE_IN)
	tween.start()
	yield(tween, "tween_completed")
	emit_signal("vanished", self)
