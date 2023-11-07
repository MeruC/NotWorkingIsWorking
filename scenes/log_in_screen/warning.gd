extends CanvasLayer

func _on_ok_btn_pressed():
	$".".visible = false
	$"../login_screen/username/username".text = ""
	$"../login_screen/password2".text = ""
