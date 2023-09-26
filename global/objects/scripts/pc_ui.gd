extends CanvasLayer


func _ready():
	pass


func _on_Exit_pressed():
	get_parent().get_node("interaction_area").out_of_range()
