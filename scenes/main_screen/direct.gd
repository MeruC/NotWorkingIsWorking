extends Control

# This script for directing users into another scene

var level_selection = "res://offline_levels/level_selection/level_selection.tscn"
var online_subMenu = "res://online_mode/level_create_Menu/level_create.tscn"
var user_profile = "res://scenes/user_profile/user_profile.tscn"
var main_shop = "res://scenes/main_shop/main_shop.tscn"
var encyclopedia = "res://encyclopedia/encyclopedia.tscn"
var net1_levels = ["res://offline_levels/level1/level_1.tscn", "res://offline_levels/level2/level2.tscn",
					"res://offline_levels/level3/level3.tscn", "res://offline_levels/level4/level4.tscn",
					"res://offline_levels/level5/level5.tscn", "res://offline_levels/level6/level6.tscn",
					"res://offline_levels/level7/level7.tscn", "res://offline_levels/level8/level8.tscn"]
export (Resource) var settings_data

func _ready():
	$mascot_animation.play("mascot_animation")
	var file = File.new()
	if not file.file_exists("user://save_data/save.dat"):
		SaveManager.save_game()

func _on_offline_button_pressed():
	Load.load_scene(self,level_selection)


func _on_online_button_pressed():
	Load.load_scene(self,online_subMenu)


func _on_profile_button_pressed():
	Load.load_scene(self,user_profile)
	#CameraTransitionDefault.transition_camera3D(get_viewport().get_camera(), $"%CameraUserProfile", 1)


func _on_shop_button_pressed():
	Load.load_scene(self,main_shop)


func _on_encyclopedia_button_pressed():
	Load.load_scene(self,encyclopedia)
	#CameraTransitionDefault.transition_camera3D(get_viewport().get_camera(), $"%CameraDictionary", 1)



func _on_objects_pressed():
	Load.load_scene(self, "res://scenes/computerTest.tscn")


func _on_quick_game_pressed():
	var random_level = pick_random_level()
	Load.load_scene(self, random_level)

# To play a random Networking 1 Level
func pick_random_level():
	var number = int(rand_range(0, net1_levels.size()))
	var selected_level = net1_levels[number]
	return selected_level
##
