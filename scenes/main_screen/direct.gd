extends Control

# This script for directing users into another scene

var level_selection = "res://offline_levels/level_selection/level_selection.tscn"
var online_subMenu = "res://online_mode/online_sub-menu/main.tscn"
var user_profile = "res://scenes/user_profile/user_profile.tscn"

func _ready():
	$mascot_animation.play("mascot_animation")
	pass # Replace with function body.



func _on_offline_button_pressed():
	get_tree().change_scene(level_selection)


func _on_online_button_pressed():
	get_tree().change_scene(online_subMenu)


func _on_profile_button_pressed():
	get_tree().change_scene(user_profile)
