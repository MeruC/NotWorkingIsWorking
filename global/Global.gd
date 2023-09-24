extends Node

#GLOBAL VARIABLES
var filesystem_shown = false
var edit_mode = true
var can_place = true
var is_usingJoystick = false
var just_onMenu = false

var main_screen = "res://scenes/main_screen/main_screen.tscn"

var w = 10
var d = 10

var curOS = OS.get_name()

func _ready():
	print(curOS)
	
var editor_mode = "place"
var e_mode_history = "place"

func _input(event):
	if(Input.is_action_just_pressed("main_menu")):
		var ro = get_node("/root")
		Load.load_scene(ro.get_child(ro.get_child_count()-1), "res://scenes/main_screen/main_screen.tscn")
	
