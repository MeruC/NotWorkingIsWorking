extends Node

#GLOBAL VARIABLES
var filesystem_shown = false
var edit_mode = true
var can_place = true
var is_usingJoystick = false
var just_onMenu = false

var player : KinematicBody
var playerCamera : Camera
var playerCameraTop : Camera
var playerCanMove = true
var playerInteractLbl : Control

var playerInEditor = false

# For QR Code
var qr_text: String = "text"
var error_correction_level: int = 0

var main_screen = "res://scenes/main_screen/main_screen.tscn"

var w = 10
var d = 10
var grid = preload("res://resources/Materials/grid.tres")
var grid_out = preload("res://resources/Materials/grid_out.tres")

var curOS = OS.get_name()

func _ready():
	print(curOS)
	
var editor_mode = "place"
var e_mode_history = "place"
var on_save_load = false
var color = "Gray"
var cable_mode = false

func _input(event):
	if(Input.is_action_just_pressed("main_menu")):
		var ro = get_node("/root")
		Load.load_scene(ro.get_child(ro.get_child_count()-1), "res://scenes/main_screen/main_screen.tscn")
	
func _scene_IN():
	TransitionNode.animation_player.play("in")
	yield(get_tree().create_timer(1), "timeout")

func _scene_OUT():
	TransitionNode.animation_player.play("out")
	yield(get_tree().create_timer(1), "timeout")
