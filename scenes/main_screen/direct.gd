extends Control

# This script for directing users into another scene

var level_selection = "res://offline_levels/level1/level1_discussion/level1.tscn"
var online_subMenu = "res://online_mode/level_create_Menu/level_create.tscn"
var user_profile = "res://scenes/user_profile/user_profile.tscn"
var main_shop = "res://scenes/main_shop/main_shop.tscn"
var encyclopedia = "res://encyclopedia/encyclopedia.tscn"
export (Resource) var settings_data

func _ready():
	$mascot_animation.play("mascot_animation")

func _on_offline_button_pressed():
	Load.load_scene(self,level_selection)


func _on_online_button_pressed():
	Load.load_scene(self,online_subMenu)


func _on_profile_button_pressed():
	Load.load_scene(self,user_profile)


func _on_shop_button_pressed():
	Load.load_scene(self,main_shop)


func _on_encyclopedia_button_pressed():
	Load.load_scene(self,encyclopedia)



func _on_objects_pressed():
	Load.load_scene(self, "res://test.tscn")
