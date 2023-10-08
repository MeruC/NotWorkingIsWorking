extends Control

# This script for directing users into another scene

var level_selection = "res://global/chapters/chapter1.tscn"
var online_subMenu = "res://online_mode/level_create_Menu/level_create.tscn"
var user_profile = "res://scenes/user_profile/user_profile.tscn"
var main_shop = "res://scenes/main_shop/main_shop.tscn"
var encyclopedia = "res://encyclopedia/encyclopedia.tscn"
var net1_levels = ["res://offline_levels/level1/level_1.tscn", "res://offline_levels/level2/level2.tscn",
					"res://offline_levels/level3/level3.tscn", "res://offline_levels/level4/level4.tscn",
					"res://offline_levels/level5/level5.tscn", "res://offline_levels/level6/level6.tscn",
					"res://offline_levels/level7/level7.tscn", "res://offline_levels/level8/level8.tscn"]
export (Resource) var settings_data

onready var tap = $tap
onready var animation_player = $AnimationPlayer
onready var settings = $settings
onready var idle = $idle



func _input(event):
	if (event is InputEventScreenTouch or event is InputEventMouseButton) and tap.visible == true:
		animation_player.play("start")
		CameraTransitionDefault.transition_camera3D(get_viewport().get_camera(), $"%CameraOffline", 1)
		yield(animation_player, "animation_finished")
		idle.play("idle")

func _ready():
	var resoltionArr = settings_data.resolution.split(" x ")
	OS.window_fullscreen = settings_data.fullscreen
	if !OS.window_fullscreen:
		match(OS.get_name()):
			"Windows":
				OS.set_window_size(Vector2(int(resoltionArr[0]), int(resoltionArr[1])))
				OS.center_window()
	else:
		var viewport = get_viewport()
		viewport.size.x = int(resoltionArr[0])
		viewport.size.y = int(resoltionArr[1])
	SignalManager.connect( "confirm", self, "_on_confirm_pressed" )
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


func _on_shop_button_pressed():
	Load.load_scene(self,main_shop)


func _on_encyclopedia_button_pressed():
	Load.load_scene(self,encyclopedia)



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


func _on_offline_btn_pressed():
	
	TransitionNode.animation_player.play("out")
	yield(TransitionNode.animation_player, "animation_finished")
	Load.load_scene(self,level_selection)


func _on_online_btn_pressed():
	
	TransitionNode.animation_player.play("out")
	yield(TransitionNode.animation_player, "animation_finished")
	Load.load_scene(self,online_subMenu)


func _on_quick_btn_pressed():
	
	TransitionNode.animation_player.play("out")
	yield(TransitionNode.animation_player, "animation_finished")
	var random_level = pick_random_level()
	Load.load_scene(self, random_level)


func _on_shop_btn_pressed():
	
	TransitionNode.animation_player.play("out")
	yield(TransitionNode.animation_player, "animation_finished")
	Load.load_scene(self,main_shop)


func _on_dict_btn_pressed():
	
	TransitionNode.animation_player.play("out")
	yield(TransitionNode.animation_player, "animation_finished")
	Load.load_scene(self,encyclopedia)


func _on_user_btn_pressed():
	
	TransitionNode.animation_player.play("out")
	yield(TransitionNode.animation_player, "animation_finished")
	Load.load_scene(self,user_profile)


func _on_settings_btn_pressed():
	settings.set_visible(true)
	settings.animation_player.play("intro")


func _on_quit_btn2_pressed():
	ConfirmDialog.set_visible(true)
	ConfirmDialog.confirm_animation.play("intro")
	ConfirmDialog.label.text = "Quit game?"
	ConfirmDialog.action = "quit"
	
func _on_confirm_pressed(action):
	match(action):
		"main_menu":
			get_tree().paused = false
			action = ""
			var ro = get_node("/root")
			Load.load_scene(ro.get_child(ro.get_child_count()-1), "res://scenes/main_screen/main_screen.tscn")
		"quit":
			action = ""
			get_tree().quit()
