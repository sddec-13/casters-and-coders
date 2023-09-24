extends PopupDialog


func show_popup(duration : float):
	self.popup()
	yield(get_tree().create_timer(duration), "timeout")
	self.hide()
