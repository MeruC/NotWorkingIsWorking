extends Control

# This script for directing users into another scene

var main_screen = "res://scenes/main_screen/main_screen.tscn"
var level1 = "res://offline_levels/level1/level1_discussion/level1_discussion.tscn"
var level2 = "res://offline_levels/level2/level2_discussion/level2_discussion.tscn"
var level3 = "res://offline_levels/level3/level3_discussion.tscn"
var level4 = "res://offline_levels/level4/level4_discussion/level4_discussion.tscn"
var level5 = "res://offline_levels/level5/level5_discussion/level5_discussion.tscn"
export (Resource) var settings_data 
	
func _ready():
	$level_container/level2.disabled = true
	$level_container/level3.disabled = true
	$level_container/level4.disabled = true
	$level_container/level5.disabled = true
	if settings_data.level1 == "complete":
		$level_container/level2.disabled = false
	if settings_data.level2 == "complete":
		$level_container/level3.disabled = false
	if settings_data.level3 == "complete":
		$level_container/level4.disabled = false
	if settings_data.level4 == "complete":
		$level_container/level5.disabled = false

func _on_back_button_pressed():
	Load.load_scene(self,main_screen)


func _on_level1_pressed():
	Load.load_scene(self,level1)


func _on_level2_pressed():
	Load.load_scene(self,level2)


func _on_level3_pressed():
	Load.load_scene(self,level3)


func _on_level4_pressed():
	Load.load_scene(self,level4)


func _on_level5_pressed():
	Load.load_scene(self,level5)
