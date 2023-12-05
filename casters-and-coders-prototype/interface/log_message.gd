extends Control

export(int) var type
export(float) var timeout = 5
export(float) var fadeout_duration = 3
export(String) var text

signal vanished()

onready var timer = Timer.new()
onready var tween = Tween.new()
onready var label: Label = $Label
onready var background: ColorRect = $ColorRect

# Called when the node enters the scene tree for the first time.
func _ready():
	label.text = text
	match type:
		Log.MSG_INFO:
			label.modulate = Color.white
		Log.MSG_ERR:
			label.modulate = Color.red
	
	var text_size = label.get_minimum_size() + Vector2(4, 0) # Add some padding at the end
	background.rect_size = text_size
	label.rect_size = text_size
	self.rect_size = text_size
	
	
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
