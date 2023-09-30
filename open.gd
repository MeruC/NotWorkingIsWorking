extends Node

export (Resource) var settings_data

func _ready():
	if settings_data.account_status == "old":
		yield(get_tree().create_timer(1),"timeout")
		Load.load_scene(self, "res://scenes/main_screen/main_screen.tscn")
	else:
		Load.load_scene(self, "res://scenes/log_in_screen/login_signup_scene.tscn")
