extends Control

export(NodePath) onready var settings = get_node(settings) as Control

func _on_settingsBtn_pressed():
	SaveManager.save_game()
	Global.e_mode_history = Global.editor_mode
	Global.editor_mode = "menu"
	settings.visible = !settings.visible
	settings.raise()
	settings.animation_player.play("intro")
