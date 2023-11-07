extends CanvasLayer

var action = ""
onready var confirm_animation = $AnimationPlayer
onready var label = $ColorRect2/Control/ColorRect/MarginContainer/VBoxContainer/Label

onready var confirm = $ColorRect2/ColorRect/MarginContainer/VBoxContainer/confirm


export(String, "Confirm Dialog", "OK Dialog") var mode = "Confirm Dialog"

func _ready():
	match mode:
		"Confirm Dialog":
			confirm.set_visible(true)
		"OK Dialog":
			confirm.set_visible(false)

#OK DIALOG
func _on_okBtn_pressed():
	confirm_animation.play("outro")
	yield(confirm_animation, "animation_finished")
	hide()
	action = ""
	
func _process(delta):
	pass
	#color_rect.set_pivot_offset(color_rect.rect_size/2)
	#color_rect_2.set_pivot_offset(color_rect_2.rect_size/2)


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
