extends Control

# This script for directing users into another scene

var previous_scene = "res://online_mode/online_sub-menu/main.tscn"
var quiz_subMenu = "res://online_mode/createQuiz_sub-menu/createQuiz_sub-menu.tscn"
var simulation = "res://online_mode/level_editor/level_editor.tscn"

func _ready():
	pass # Replace with function body.


func _on_quiz_pressed():
	get_tree().change_scene(quiz_subMenu)


func _on_simulation_pressed():
	get_tree().change_scene(simulation)
