extends Button

onready var menu_animations = $"%MenuAnimations"
onready var joystick_editor = $"%joystickEditor"


func _on_menu_pressed():
	if self.pressed:
		menu_animations.play("menu")
		joystick_editor.use_input_actions = false
		joystick_editor.set_visible(false)
	else:
		menu_animations.play_backwards("menu")
		yield(menu_animations, "animation_finished")
		joystick_editor.use_input_actions = true
		joystick_editor.set_visible(true)
