extends CanvasLayer

const MSG_INFO = 0
const MSG_ERR = 1

export(float) var message_timeout = 5
export(float) var message_fade_duration = 2
export(float) var max_concurrent_messages = 4000

onready var anchor = $LogAnchor
onready var printing_too_fast_warning = $PrintingTooFastWarning

var messages = []
var message_node = preload("res://interface/LogMessage.tscn")

func push_message(text: String, type: int = MSG_INFO):
	if messages.size() > max_concurrent_messages:
		printing_too_fast_warning.visible = true
		return
	
	var message = message_node.instance()
	message.text = text
	message.type = type
	anchor.add_child(message)
	var message_height = message.label.rect_size.y
	var vertical_offset = Vector2(0, -message_height)
	messages.push_front(message)
	for i in messages.size():
		var m = messages[i] as Control
		var m_pos = m.rect_position
		m.set_position(m_pos + vertical_offset)
	
	message.connect("vanished", self, "_on_message_vanished")
	

func _on_message_vanished(message):
	messages.erase(message)
	message.queue_free()
	if messages.size() <= max_concurrent_messages:
		printing_too_fast_warning.visible = false
