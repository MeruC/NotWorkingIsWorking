extends Control

# This script for directing users into another scene

var previous_scene = "res://online_mode/online_sub-menu/main.tscn"
var join_scene = "res://online_mode/join_level/join_level.tscn"
var create_subMenu = "res://online_mode/level_create_Menu/level_create.tscn"

func _ready():
	pass # Replace with function body.



func _on_join_pressed():
	get_tree().change_scene(join_scene)


func _on_create_pressed():
	get_tree().change_scene(create_subMenu)


func _on_back_pressed():
	get_tree().change_scene(previous_scene)
