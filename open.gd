	extends Node


func _ready():
	var file2Check = File.new()
	var pathToCheck = "user://save_data/save.dat"
	var doFileExists = file2Check.file_exists(pathToCheck)

	if doFileExists:
		yield(get_tree().create_timer(1), "timeout")
		Load.load_scene(self, "res://scenes/main_screen/main_screen.tscn")
	else:
		OS.window_fullscreen = true
		var viewport = get_viewport()
		viewport.size.x = 1280
		viewport.size.y = 720
		Load.load_scene(self, "res://scenes/log_in_screen/login_signup_scene.tscn")
