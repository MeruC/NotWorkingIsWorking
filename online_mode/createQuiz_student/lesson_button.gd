extends Button

export(NodePath) onready var lesson_name
export(NodePath) onready var popup

func _ready():
	pass # Replace with function body.

func _on_lesson_button_pressed():
	lesson_name.text = text
	popup.visible = false
	
