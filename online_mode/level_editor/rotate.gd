extends Control

var current_object
onready var level = get_node("/root/editor/level")

func _on_rotate_pressed():
	level.saved = false
	current_object.rotate(Vector3(0,1,0),-(PI/2))


func _on_done_pressed():
	yield(get_tree().create_timer(0.2),"timeout")
	Global.editor_mode = "rotate"
	set_visible(false)
