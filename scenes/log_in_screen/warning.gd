extends CanvasLayer

func _on_ok_btn_pressed():
	$".".visible = false
	$"../signup_screen/s_username/s_username".text = ""
	$"../signup_screen/s_password/s_password".text = ""
	$"../signup_screen/_confirmpassword/cpassword".text = ""
	$"../login_screen/username/username".text = ""
	$"../login_screen/password2".text = ""
