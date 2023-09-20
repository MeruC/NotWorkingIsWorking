extends CanvasLayer

func _ready():
	$"../login_screen".visible = false
func _on_login_btn_pressed():
	$"../login_screen".visible = true
	$".".visible = false

func _on_signup_btn_pressed():
	$"../signup_screen".visible = true
	$".".visible = false
