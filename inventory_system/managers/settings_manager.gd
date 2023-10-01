extends Node

var fullscreen setget set_fullscreen
var pixelize setget set_pixelize
var pixel_size setget set_pixel_size
var scale setget set_scale
var master_volume setget set_master_volume
var sound_volume setget set_sound_volume
var music_volume setget set_music_volume
var settings_data : Settings_Data

func _ready():
	settings_data = preload( "res://inventory_system/data/resources/settings_data.tres" )
	scale = settings_data.scale
	fullscreen = settings_data.fullscreen
	master_volume = settings_data.master_volume
	music_volume = settings_data.music_volume
	sound_volume = settings_data.sound_volume
	settings_data.connect( "changed", self, "_on_data_changed" )
	
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

func set_scale( value ):
	scale = value
	SignalManager.emit_signal( "ui_scale_changed", value )
	settings_data.scale = value

func _on_data_changed():
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
