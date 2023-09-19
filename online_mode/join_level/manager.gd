extends Control

# This script for directing users into another scene

var previous_scene = "res://online_mode/online_sub-menu/main.tscn"
var levels_folder = "res://online_mode/saved_levels/"

export(NodePath) onready var textfield = get_node(textfield) as LineEdit
export(NodePath) onready var error_popup = get_node(error_popup) as Control

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_back_pressed():
	get_tree().change_scene(previous_scene)


func _on_join_pressed():
	var level_scene = textfield.text.to_upper() + ".tscn"
	var file = File.new()
	var full_path = levels_folder + level_scene
	
	if file.open(full_path, File.READ) == OK:
		file.close()
		get_tree().change_scene(full_path)
	else:
		error_popup.visible = true
		textfield.text = ""


func _on_continue_pressed():
	error_popup.visible = false
