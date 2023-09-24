extends Button

onready var menu_animations = $"%MenuAnimations"


func _on_modeMenu_pressed():
	if self.pressed:
		menu_animations.play("mode")
	else:
		menu_animations.play_backwards("mode")
