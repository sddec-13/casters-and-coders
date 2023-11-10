extends PopupDialog


func show_popup(message: String, duration : float):
	$Label.text = message
	self.popup()
	yield(get_tree().create_timer(duration), "timeout")
	self.hide()
	
func event_show_popup():
	self.popup()

func event_hide_popup():
	self.hide()
