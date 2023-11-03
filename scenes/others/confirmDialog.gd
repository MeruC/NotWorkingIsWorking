extends CanvasLayer

var action = ""
onready var confirm_animation = $AnimationPlayer
onready var label = $ColorRect2/ColorRect/MarginContainer/VBoxContainer/Label

onready var confirm = $ColorRect2/ColorRect/MarginContainer/VBoxContainer/confirm
onready var ok = $ColorRect2/ColorRect/MarginContainer/VBoxContainer/ok


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
	confirm_animation.play("outro")
	yield(confirm_animation, "animation_finished")
	hide()
	SignalManager.emit_signal("confirm", action)
	action = ""

func _on_cancel_pressed():
	confirm_animation.play("outro")
	yield(confirm_animation, "animation_finished")
	hide()
	action = ""


func _on_disconnect_confirm_visibility_changed():
	confirm_animation.play("intro")
