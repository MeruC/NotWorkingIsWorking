extends Node2D

var edit_avatar = "res://user_profile/change_avatar.tscn"
var main_menu = "res://scenes/main_screen/main_screen.tscn"
export( Resource ) var settings_data

func _ready():
	$user_profile/name_background/name.text = settings_data.player_name
	print(settings_data.player_name)
func _on_edit_avatar_pressed():
	$user_profile.visible = false
	$edit_avatar.visible = true

func _on_back_btn_pressed():
	get_tree().change_scene(main_menu)
