extends ColorRect

onready var submenu = $submenu
onready var video_submenu = $videoSubmenu
onready var music_submenu = $musicSubmenu
export( NodePath ) onready var fullscreen_check = get_node( fullscreen_check ) as CheckBox
export( NodePath ) onready var master_vol_slider = get_node( master_vol_slider ) as HSlider
export( NodePath ) onready var music_vol_slider = get_node( music_vol_slider ) as HSlider
export( NodePath ) onready var sound_vol_slider = get_node( sound_vol_slider ) as HSlider

export( Resource ) var settings_data

func _ready():
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
	submenu.hide()
	video_submenu.set_visible(true)

func _on_music_pressed():
	submenu.hide()
	music_submenu.set_visible(true)

func _on_resume_pressed():
	hide()
	
func _on_main_menu_pressed():
	var ro = get_node("/root")
	Load.load_scene(ro.get_child(ro.get_child_count()-1), "res://scenes/main_screen/main_screen.tscn")
	
#Video Submenu
func _on_fullscreen_toggled(button_pressed):
	SettingsManager.fullscreen = button_pressed

func _on_cancel_pressed():
	SaveManager.load_game()
	submenu.set_visible(true)
	music_submenu.set_visible(false)
	video_submenu.set_visible(false)
	
func _on_save_pressed():
	SaveManager.save_game()
	submenu.set_visible(true)
	music_submenu.set_visible(false)
	video_submenu.set_visible(false)
	
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



