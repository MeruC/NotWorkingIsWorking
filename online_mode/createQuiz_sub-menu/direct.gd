extends Control

# This script for directing users into another scene

var previous_scene = "res://online_mode/create_sub-menu/create_sub-menu.tscn"
var student_quiz = "res://online_mode/createQuiz_student/createQuiz_student.tscn"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func _on_student_pressed():
	Load.load_scene(self,student_quiz)
