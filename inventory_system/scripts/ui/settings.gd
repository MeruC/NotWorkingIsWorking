extends Scale_Control

export( NodePath ) onready var scale_slider = get_node( scale_slider ) as HSlider
export( NodePath ) onready var fullscreen_check = get_node( fullscreen_check ) as CheckBox
export( NodePath ) onready var lbl_min = get_node( lbl_min ) as Label
export( NodePath ) onready var lbl_max = get_node( lbl_max ) as Label
export( NodePath ) onready var lbl_current = get_node( lbl_current ) as Label

export( Resource ) var settings_data

func _ready():
	lbl_min.text = "Min: %s" % scale_slider.min_value
	lbl_max.text = "Max: %s" % scale_slider.max_value
	lbl_current.text = "%s" % scale_slider.value
	settings_data.connect( "changed", self, "_on_data_changed" )
	_on_data_changed()
	

func _on_close_pressed():
	get_parent().hide()

# Update the scale of the ui using the ScaleControl.
func _on_scale_slider_gui_input( event ):
	if event is InputEventMouseButton and event.button_index == BUTTON_LEFT and not event.pressed:
		SettingsManager.scale = scale_slider.value
		lbl_current.text = "%s" % scale_slider.value

# Change the fullscreen toggle.
func _on_CheckBox_toggled( button_pressed ):
	SettingsManager.fullscreen = button_pressed

# Update the inputs when the data changes. ( Ex. On game load. )
func _on_data_changed():
	fullscreen_check.pressed = settings_data.fullscreen
	scale_slider.value = settings_data.scale

func _on_quit_pressed():
	var ro = get_node("/root")
	Load.load_scene(ro.get_child(ro.get_child_count()-1), "res://scenes/main_screen/main_screen.tscn")

func _on_save_pressed():
	SaveManager.save_game()

func _on_load_pressed():
	SaveManager.load_game()
	get_parent().hide()
