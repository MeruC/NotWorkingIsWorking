extends Control

# This script for directing users into another scene

export(NodePath) onready var popup = get_node(popup) as Control
export(NodePath) onready var keycode_lineEdit = get_node(keycode_lineEdit) as LineEdit

var key_code = "12345678" # This is just a sample key code. Key code should be fetched from the DB
var previous_scene = "res://online_mode/create_sub-menu/create_sub-menu.tscn"
var student_quiz = "res://online_mode/createQuiz_student/createQuiz_student.tscn"
var prof_quiz = "res://online_mode/createQuiz_professor/createQuiz_professor.tscn"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func _on_student_pressed():
	Load.load_scene(self,student_quiz)


func _on_professor_pressed():
	popup.visible = true


func _on_submit_button_pressed():
	if keycode_lineEdit.text == key_code:
		Load.load_scene(self, prof_quiz)
	else:
		keycode_lineEdit.text = ""
		keycode_lineEdit.placeholder_text = "Invalid Key Code"


func _on_close_button_pressed():
	popup.visible = false


func _on_create_levels_pressed():
	Load.load_scene(self, "res://online_mode/quiz_results/view_createdlevels.tscn")


func _on_back_pressed():
	queue_free()
	Load.load_scene(self, "res://online_mode/level_create_Menu/level_create.tscn")
