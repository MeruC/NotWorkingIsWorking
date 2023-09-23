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
		settings_data.player_data(nickname)
		# Hide elements and perform other actions as needed
		$".".visible = false
		$"../select_gender".visible = true
		SaveManager.save_game()
		$"../AnimationPlayer".play("male_anim")

func _on_data_changed():
	# Update the input field with the player's name from settings_data
	$Username/LineEdit.text = settings_data.player_name
	settings_data.rank = "rookie"
	settings_data.account_status = "old"
	settings_data.net1_skills = 0
	settings_data.net2_skills = 0

		
