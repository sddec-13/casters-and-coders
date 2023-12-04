extends Node2D

onready var anim = $AnimationPlayer
onready var interactable = $Interactable
onready var label = $Label

signal number_changed

export var console_number = 1
export var number = 0
export var max_number = 9

# Called when the node enters the scene tree for the first time.
func _ready():
	label.text = str(number)
	interactable.connect("interacted", self, "_interacted")

func _interacted():
	anim.play("press_button")
	increment_number()
	
func increment_number():
	number = number + 1
	if number > max_number:
		number = 0
	label.text = str(number)
	emit_signal("number_changed", number)
