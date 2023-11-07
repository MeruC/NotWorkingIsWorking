extends TextEdit

export(int) var LIMIT = 10


func _on_TextEdit_text_changed():
	#print(self.get_text().length())
	if self.get_text().length() > LIMIT:
		var text = self.get_text()
		text.erase(LIMIT - 1, self.get_text().length())
		print(text)
		self.text = text
		self.readonly = true
	elif self.get_text().length() == LIMIT:
		self.readonly = true
		
func _input(event):
	if Input.is_action_just_pressed("backspace"):
		if self.readonly == true:
			self.readonly = false
			self.grab_focus()
