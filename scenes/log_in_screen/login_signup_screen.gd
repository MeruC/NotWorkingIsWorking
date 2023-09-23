extends CanvasLayer

export (Resource) var settings_data 

func _ready():
	$"../login_screen".visible = false
	if settings_data.player_name and settings_data.gender != "":
		get_tree().change_scene("res://scenes/main_screen/main_screen.tscn")
func _on_login_btn_pressed():
	$"../login_screen".visible = true
	$".".visible = false

func _on_signup_btn_pressed():
	$"../signup_screen".visible = true
	$".".visible = false
