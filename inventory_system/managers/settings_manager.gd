extends Node

var resolution setget set_resolution
var fullscreen setget set_fullscreen
var pixelize setget set_pixelize
var pixel_size setget set_pixel_size
var scale setget set_scale
var master_volume setget set_master_volume
var sound_volume setget set_sound_volume
var music_volume setget set_music_volume
var settings_data : Settings_Data

var changeRes = ""

func _ready():
	settings_data = preload( "res://inventory_system/data/resources/settings_data.tres" )
	scale = settings_data.scale
	fullscreen = settings_data.fullscreen
	master_volume = settings_data.master_volume
	music_volume = settings_data.music_volume
	sound_volume = settings_data.sound_volume
	settings_data.connect( "changed", self, "_on_data_changed" )
	changeRes = settings_data.resolution
	
func set_resolution( value ):
	changeRes = value
	resolution = value
	var resoltionArr = value.split(" x ")
	if !OS.window_fullscreen:
		match(OS.get_name()):
			"Windows":
				OS.set_window_size(Vector2(int(resoltionArr[0]), int(resoltionArr[1])))
				OS.center_window()
	else:
		var viewport = get_viewport()
		viewport.size.x = int(resoltionArr[0])
		viewport.size.y = int(resoltionArr[1])
	settings_data.resolution = value

func set_pixelize( value ):
	pixelize = value
	Pixelizer.set_visible(value)
	settings_data.pixelize = value

func set_pixel_size( value ):
	pixel_size = value
	Pixelizer.material.set_shader_param("pixelSize", value)
	settings_data.pixel_size = value
	

func set_fullscreen( value ):
	fullscreen = value
	OS.window_fullscreen = value
	settings_data.fullscreen = value
	var viewport = get_viewport()
	var resoltionArr = changeRes.split(" x ")
	viewport.size.x = int(resoltionArr[0])
	viewport.size.y = int(resoltionArr[1])

func set_scale( value ):
	scale = value
	SignalManager.emit_signal( "ui_scale_changed", value )
	settings_data.scale = value

func _on_data_changed():
	set_resolution(settings_data.resolution)
	set_pixel_size( settings_data.pixel_size )
	set_pixelize(settings_data.pixelize)
	set_fullscreen( settings_data.fullscreen )
	set_scale( settings_data.scale )
	set_master_volume(settings_data.master_volume)
	set_sound_volume(settings_data.sound_volume)
	set_music_volume(settings_data.music_volume)
	
func set_master_volume( value ):
	master_volume = value
	volume(0, value)
	if (value == -50):
		mute(0, true)
	else:
		mute(0, false)
	settings_data.master_volume = value
		
func set_sound_volume( value ):
	sound_volume = value
	volume(1, value)
	if (value == -50):
		mute(1, true)
	else:
		mute(1, false)
	settings_data.sound_volume = value
		
func set_music_volume( value ):
	music_volume = value
	volume(2, value)
	if (value == -50):
		mute(2, true)
	else:
		mute(2, false)
	settings_data.music_volume = value
		
func volume(bus_index, value):
	AudioServer.set_bus_volume_db(bus_index, value)
	
func mute(bus_index, boolean):
	AudioServer.set_bus_mute(bus_index, boolean)
