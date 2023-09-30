extends CanvasLayer

export (Resource) var settings_data 

func _ready():
	$"../login_screen".visible = false
				
func _on_login_btn_pressed():
	$"../login_screen".visible = true
	$".".visible = false

func _on_signup_btn_pressed():
	$"../signup_screen".visible = true
	$".".visible = false

func _on_skip_pressed():
	$"..".queue_free()
	Load.load_scene(self, "res://scenes/create_account/create_account.tscn")
