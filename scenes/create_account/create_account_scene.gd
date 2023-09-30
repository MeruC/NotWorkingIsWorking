extends CanvasLayer

export( Resource ) var settings_data

func _ready():
	pass
func _on_confirm_pressed():
	var nickname_input = $Username/LineEdit
	var nickname = nickname_input.text
	if nickname == "":
		$Label.text = "Invalid nickname"
	else:
		# Update the player_name property of settings_data
		var player_name = $Username/LineEdit.text
		settings_data.player_name = $Username/LineEdit.text
		settings_data.rank = "rookie"
		settings_data.account_status = "old"
		settings_data.net1_skills = 0
		settings_data.net2_skills = 0
		# Hide elements and perform other actions as needed
		$".".visible = false
		$"../select_gender".visible = true
		SaveManager.save_game()
		$"../AnimationPlayer".play("male_anim")
