extends LineEdit

func _ready():
	# Connect the "text_changed" signal to the "_on_text_changed" method
	connect("text_changed", self, "_on_text_changed")

func _on_second_focus_exited():
	var new_text = "0"
	
	if text.length() == 1:
		new_text += text
		text = new_text
