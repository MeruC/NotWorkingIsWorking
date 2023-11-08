extends Panel

export (NodePath) onready var content_holder
export (NodePath) onready var term_label
export (String) var definition
export (String) var image

func _ready():
	pass # Replace with function body.


func _on_onclick_pressed():
	content_holder.text = definition
	term_label.text = $word.text
