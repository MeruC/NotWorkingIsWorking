extends Button


func _on_back_btn_pressed():
	$"..".visible = false
	$"../../signup_screen".visible = false
	$"../../login_signup_screen".visible = true
