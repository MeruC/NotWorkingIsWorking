extends Control

export(NodePath) onready var pause_popup = get_node(pause_popup) as Control
var home_screen = "res://main_screen/main_screen.tscn"

func _ready():
	pass

func _on_pause_button_pressed():
	pause_popup.visible = true


func _on_home_pressed():
	Load.load_scene(self,home_screen)


func _on_restart_pressed():
	var current_scene = get_tree().get_current_scene().get_filename()
	Load.load_scene(self,current_scene)


func _on_continue_pressed():
	pause_popup.visible = false
