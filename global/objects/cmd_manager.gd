extends Control

export(PackedScene) var command_line_scene
signal enter_pressed
var command_entered

func _ready():
	set_process_input(true)
	
func _input(event):
	if event is InputEventKey and event.scancode == KEY_ENTER and event.pressed:
		scan_command()
	else:
		pass
		
func scan_command():
	self.editable = false
	command_entered = text.strip_edges().to_lower()
	
	if command_entered.find("ping") == 0:
		ping_device()
	print(command_entered)
