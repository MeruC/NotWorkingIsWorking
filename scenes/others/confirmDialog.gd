extends ColorRect

var action = ""
onready var confirm_animation = $AnimationPlayer
onready var label = $ColorRect/MarginContainer/VBoxContainer/Label

onready var confirm = $ColorRect/MarginContainer/VBoxContainer/confirm
onready var ok = $ColorRect/MarginContainer/VBoxContainer/ok


export(String, "Confirm Dialog", "OK Dialog") var mode = "Confirm Dialog"

func _ready():
	match mode:
		"Confirm Dialog":
			ok.set_visible(false)
			confirm.set_visible(true)
		"OK Dialog":
			confirm.set_visible(false)
			ok.set_visible(true)

#OK DIALOG
func _on_okBtn_pressed():
	pass # Replace with function body.


#CONFIRM DIALOG
func _on_confirm_pressed():
	match(action):
		"main_menu":
			get_tree().paused = false
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
