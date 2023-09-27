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
	audio_loop_player.play()
	audio_loop_player.stream_paused = true
	settings_data.connect( "changed", self, "_on_data_changed" )
	_on_data_changed()

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
	hide()
	
func _on_main_menu_pressed():
	confirm.set_visible(true)
	confirm.confirm_animation.play("intro")
	confirm.label.text = "Return to Main Menu?"
	confirm.action = "main_menu"
	
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

func _on_quit_pressed():
	confirm.set_visible(true)
	confirm.confirm_animation.play("intro")
	confirm.label.text = "Quit game?"
	confirm.action = "quit"


func _on_restart_pressed():
	get_tree().reload_current_scene()
	get_tree().paused = false
