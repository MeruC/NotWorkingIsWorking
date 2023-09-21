extends Button

func _on_back_btn_pressed():
	$"..".visible = false
	$"../../login_screen".visible = false
	$"../../login_signup_screen".visible = true
