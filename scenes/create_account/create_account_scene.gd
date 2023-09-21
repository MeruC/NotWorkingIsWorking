extends CanvasLayer

var gender

func _on_CheckButton_toggled(button_pressed):
	var player_gender_selection = get_node(".")
	if player_gender_selection:
		# The node was found, so emit the signal.
		if button_pressed:
			gender = "male"
			player_gender_selection.emit_signal("selected_gender", gender)
			print("male")
		else:
			gender = "female"
			print("female")
			player_gender_selection.emit_signal("selected_gender", gender)
	else:
		# The node was not found. Print an error message.
		print("Error: 'path/to/Spatial_node' not found in the scene.")

