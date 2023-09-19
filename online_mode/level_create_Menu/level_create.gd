extends Control

export( NodePath ) onready var width = get_node(width) as SpinBox
export( NodePath ) onready var depth = get_node(depth) as SpinBox
export( NodePath ) onready var playarea = get_node(playarea) as CSGBox
export( NodePath ) onready var camera = get_node(camera) as Camera

var quiz_subMenu = "res://online_mode/createQuiz_sub-menu/createQuiz_sub-menu.tscn"


var cur_w = 10
var cur_d = 10

var menu = 0

onready var player = get_node("AnimationPlayer")
onready var idle = $idle
onready var choosetype = $choosetype
onready var level3d = $"3dlevel"




func _ready():
	player.get_animation("ui").set_loop(true)



# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_create_pressed():
	Global.w = cur_w
	Global.d = cur_d
	get_tree().change_scene_to(load("res://online_mode/level_editor/level_editor.tscn"))


func _on_w_value_changed(value):
	cur_w = value
	playarea.set_width(cur_w * 2)
	if cur_w >= cur_d:
		camera.fov = cur_w
	else:
		camera.fov = cur_d
			


func _on_d_value_changed(value):
	cur_d = value
	playarea.set_depth(cur_d * 2)
	if cur_w >= cur_d:
		camera.fov = cur_w
	else:
		camera.fov = cur_d


func _on_inventory_test_pressed():
	get_tree().change_scene_to(load("res://nodes/inventory.tscn"))


func _on_back_pressed():
	choosetype.set_visible(true)
	idle.stop()
	player.play_backwards("set_size")
	yield(player, "animation_finished")
	level3d.set_visible(false)

func _on_3dlevel_pressed():
	level3d.set_visible(true)
	player.play("set_size")
	yield(player, "animation_finished")
	idle.play("ui")
	choosetype.set_visible(false)


func _on_backtoMain_pressed():
	get_tree().change_scene("res://scenes/main_screen/main_screen.tscn")


func _on_quiz_pressed():
	get_tree().change_scene(quiz_subMenu)
