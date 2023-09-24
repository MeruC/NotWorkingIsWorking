extends Node

func _ready():
	yield(get_tree().create_timer(1),"timeout")
	Load.load_scene(self, "res://scenes/main_screen/main_screen.tscn")

