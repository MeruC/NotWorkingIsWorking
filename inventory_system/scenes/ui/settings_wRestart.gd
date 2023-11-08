extends ColorRect

onready var pausemenu = $pausemenu
onready var submenu = $settingsubmenu
onready var video_submenu = $videoSubmenu
onready var music_submenu = $musicSubmenu
export( NodePath ) onready var fullscreen_check = get_node( fullscreen_check ) as CheckBox
export( NodePath ) onready var master_vol_slider = get_node( master_vol_slider ) as HSlider
export( NodePath ) onready var music_vol_slider = get_node( music_vol_slider ) as HSlider
export( NodePath ) onready var sound_vol_slider = get_node( sound_vol_slider ) as HSlider
onready var confirm = $confirm

export( Resource ) var settings_data

onready var animation_player = $AnimationPlayer
var menu = 0

onready var audio_loop_player = $AudioLoopPlayer

func _ready():
	SignalManager.connect( "ok", self, "_on_ok_pressed" )
	SignalManager.connect( "confirm", self, "_on_confirm_pressed" )
	audio_loop_player.play()
	audio_loop_player.stream_paused = true
	settings_data.connect( "changed", self, "_on_data_changed" )
	_on_data_changed()

func _on_ok_pressed(action):
	pass
	
func _on_confirm_pressed(action):
	match(action):
		"main_menu":
			get_tree().paused = false
			action = ""
			settings_data.quick_game = "notplaying"
			settings_data.online_level = ""
			SaveManager.save_game()
			var ro = get_node("/root")
			Load.load_scene(ro.get_child(ro.get_child_count()-1), "res://scenes/main_screen/main_screen.tscn")
		"quit":
			action = ""
			get_tree().quit()
			
func _on_main_menu_pressed():
	ConfirmDialog.set_visible(true)
	ConfirmDialog.confirm_animation.play("intro")
	ConfirmDialog.label.text = "Return to Main Menu?"
	ConfirmDialog.action = "main_menu"
	
func _on_quit_pressed():
	ConfirmDialog.set_visible(true)
	ConfirmDialog.confirm_animation.play("intro")
	ConfirmDialog.label.text = "Quit game?"
	ConfirmDialog.action = "quit"

# Update the inputs when the data changes. ( Ex. On game load. )
func _on_data_changed():
	fullscreen_check.pressed = settings_data.fullscreen
	master_vol_slider.value = settings_data.master_volume
	music_vol_slider.value = settings_data.music_volume
	sound_vol_slider.value = settings_data.sound_volume
	#scale_slider.value = settings_data.scale

#Main Settings Menu
func _on_video_pressed():
	animation_player.play("video")
	menu = 1

func _on_music_pressed():
	animation_player.play("music")
	menu = 2

func _on_resume_pressed():
	animation_player.play_backwards("intro")
	get_tree().paused = false
	yield(animation_player, "animation_finished")
	audio_loop_player.stream_paused = true
	audio_loop_player.stop()
	#audio_loop_player.playing = false
	get_parent().set_visible(false)

#Video Submenu
func _on_fullscreen_toggled(button_pressed):
	SettingsManager.fullscreen = button_pressed

func _on_cancel_pressed():
	SaveManager.load_game()
	match(menu):
		1:
			animation_player.play_backwards("video")
			menu = 0
		2:
			animation_player.play_backwards("music")
			menu = 0 
	
func _on_save_pressed():
	SaveManager.save_game()
	match(menu):
		1:
			animation_player.play_backwards("video")
			menu = 0
		2:
			animation_player.play_backwards("music")
			menu = 0 
	
#Music Submenu
func _on_master_value_changed(value):
	SettingsManager.master_volume = value

func _on_music_value_changed(value):
	SettingsManager.music_volume = value

func _on_sound_value_changed(value):
	SettingsManager.sound_volume = value

func volume(bus_index, value):
	AudioServer.set_bus_volume_db(bus_index, value)
	
func mute(bus_index, boolean):
	AudioServer.set_bus_mute(bus_index, boolean)

func _on_settings_btn_pressed():
	animation_player.play("submenu")

func _on_back_pressed():
	animation_player.play_backwards("submenu")

func _on_restart_pressed():
	get_tree().reload_current_scene()
	get_tree().paused = false
