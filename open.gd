extends Node

func _ready():
	yield(get_tree().create_timer(1),"timeout")
	Load.load_scene(self, "res://scenes/log_in_screen/login_signup_scene.tscn")
