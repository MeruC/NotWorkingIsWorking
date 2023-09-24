extends CanvasLayer

export (Resource) var settings_data 

func _ready():
	$"../login_screen".visible = false
		
func _process(delta):
	if settings_data:
		account_validation()
		
func _on_login_btn_pressed():
	$"../login_screen".visible = true
	$".".visible = false

func _on_signup_btn_pressed():
	$"../signup_screen".visible = true
	$".".visible = false
	
func account_validation():
	if settings_data.account_status == "old":
		$"..".queue_free()
		Load.load_scene(self,"res://scenes/main_screen/main_screen.tscn")
