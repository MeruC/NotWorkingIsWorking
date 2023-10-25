extends LineEdit
onready var result_line = get_parent().get_parent().find_node("result")
signal enter_pressed(text, result_line)
onready var command_line = $"."
var command_entered
var size

func _input(event):
	if event is InputEventKey and event.scancode == KEY_ENTER and event.pressed and command_line.has_focus():
		emit_signal("enter_pressed", text.strip_edges().to_lower(), result_line)
		self.editable = false
