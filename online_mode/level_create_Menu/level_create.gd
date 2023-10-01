extends Control

export( NodePath ) onready var width = get_node(width) as SpinBox
export( NodePath ) onready var depth = get_node(depth) as SpinBox
export( NodePath ) onready var playarea = get_node(playarea) as CSGBox
export( NodePath ) onready var camera = get_node(camera) as Camera

var quiz_subMenu = "res://online_mode/createQuiz_sub-menu/createQuiz_sub-menu.tscn"
var join_scene = "res://online_mode/join_level/join_level.tscn"
var level_editor = "res://online_mode/level_editor/level_editor.tscn"

var cur_w = 10
var cur_d = 10

var menu = 0

onready var player = get_node("AnimationPlayer")
onready var idle = $idle
onready var choosetype = $choosetype
onready var level3d = $"3dlevel"

onready var animation_player = $AnimationPlayer




func _ready():
	TransitionNode.animation_player.play("in")
	yield(get_tree().create_timer(0.5), "timeout")
	animation_player.play("intro")
	player.get_animation("ui").set_loop(true)



# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_create_pressed():
	Global.w = cur_w
	Global.d = cur_d
	Load.load_scene(self, level_editor)


func _on_w_value_changed(value):
	cur_w = value
	playarea.set_width(cur_w * 2)
	if cur_w >= cur_d:
		camera.fov = cur_w
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
	Load.load_scene(self,"res://scenes/main_screen/main_screen.tscn")


func _on_quiz_pressed():
	Load.load_scene(self,quiz_subMenu)




func _on_create_level_pressed():
	player.play("choosetype")


func _on_back2menu_pressed():
	player.play_backwards("choosetype")


func _on_play_pressed():
	Load.load_scene(self,join_scene)
	pass # Replace with function body.
