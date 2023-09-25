extends ColorRect

var action = ""
onready var confirm_animation = $AnimationPlayer
onready var label = $ColorRect/MarginContainer/VBoxContainer/Label


func _on_confirm_pressed():
	match(action):
		"main_menu":
			
			action = ""
			var ro = get_node("/root")
			Load.load_scene(ro.get_child(ro.get_child_count()-1), "res://scenes/main_screen/main_screen.tscn")
		"quit":
			action = ""
			get_tree().quit()

func _on_cancel_pressed():
	confirm_animation.play("outro")
	yield(confirm_animation, "animation_finished")
	hide()
	action = ""
