extends CanvasLayer

func _ready():
	TransitionNode.raise()
	TransitionNode.animation_player.play("in")
	yield(get_tree().create_timer(0.5), "timeout")


func _on_save_pressed():
	SaveManager.save_game()
	var ro = get_node("/root")
	Load.load_scene(self, "res://scenes/main_screen/main_screen.tscn")


func _on_cancel_pressed():
	SaveManager.load_game()
	var ro = get_node("/root")
	Load.load_scene(self, "res://scenes/main_screen/main_screen.tscn")
