extends Button

onready var menu_animations = $"%MenuAnimations"

func _on_menu_pressed():
	if self.pressed:
		menu_animations.play("menu")
	else:
		menu_animations.play_backwards("menu")
