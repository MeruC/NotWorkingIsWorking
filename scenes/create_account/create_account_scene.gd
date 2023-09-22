extends CanvasLayer

export( Resource ) var settings_data

func _ready():

	settings_data.connect("changed", self, "_on_data_changed")
	

func _on_confirm_pressed():
	var nickname_input = $Username/LineEdit
	var nickname = nickname_input.text
	if nickname == "":
		$Label.text = "Invalid nickname"
	else:
		# Update the player_name property of settings_data
		settings_data.player_name = nickname

		# Hide elements and perform other actions as needed
		$".".visible = false
		$"../select_gender".visible = true
		SaveManager.save_game()

func _on_data_changed():
	# Update the input field with the player's name from settings_data
	$Username/LineEdit.text = settings_data.player_name
