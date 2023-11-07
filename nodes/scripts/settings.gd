extends Control

export(NodePath) onready var settings = get_node(settings) as ColorRect
onready var canvas_layer = $CanvasLayer

func _on_settingsBtn_pressed():
	SaveManager.save_game()
	Global.e_mode_history = Global.editor_mode
	Global.editor_mode = "menu"
	canvas_layer.visible = not canvas_layer.visible
	settings.raise()
	#settings.set_visible(true)
	settings.animation_player.play("intro")
	yield(settings.animation_player, "animation_finished")
	get_tree().paused = true
	settings.audio_loop_player.stream_paused = false
	Global.editor_mode = "play"


func _on_settingsBtn_pressed2():
	SaveManager.save_game()
	Global.e_mode_history = Global.editor_mode
	Global.editor_mode = "menu"
	canvas_layer.visible = not canvas_layer.visible
	settings.raise()
	#settings.set_visible(true)
	settings.animation_player.play("intro")
	yield(settings.animation_player, "animation_finished")
	get_tree().paused = true
	#settings.audio_loop_player.stream_paused = false
	Global.editor_mode = "play"
