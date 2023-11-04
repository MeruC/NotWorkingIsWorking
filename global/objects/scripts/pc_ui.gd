extends CanvasLayer

onready var io = $io
onready var pc_screen = $pc_screen
onready var camera = $"../interaction_area/Camera"
onready var camera_2 = $"../interaction_area/Camera2"
onready var fe_cable = $io/cpu_ui/fe_cable
onready var disconnect_button = $io/cpu_ui/disconnect_button
onready var console_cable = $io/cpu_ui/console_cable
onready var disconnect_consoleBtn = $io/cpu_ui/disconnect_console

var red = Color("#8a0000")
var blue = Color("#001480")

func _on_Exit_pressed():
	get_parent().get_node("interaction_area").out_of_range()


func _on_to_io_pressed():
	pc_screen.set_visible(false)
	yield(CameraTransition.transition_camera3D(camera, camera_2, 1), "completed")
	io.set_visible(true)
	display_wires(get_parent())
	
func display_wires(node):
	if node.fe0_type == "cross_over":
		fe_cable.color = blue
		fe_cable.visible = true
		disconnect_button.visible = true
	elif node.fe0_type == "straight_through":
		fe_cable.color = red
		fe_cable.visible = true
		disconnect_button.visible = true
	else:
		fe_cable.visible = false
		disconnect_button.visible = false
	
	if node.console_port0 != null:
		console_cable.visible = true
		disconnect_consoleBtn.visible = true
	else:
		console_cable.visible = false
		disconnect_consoleBtn.visible = false
		


func _on_to_pc_pressed():
	io.set_visible(false)
	yield(CameraTransition.transition_camera3D(camera_2, camera, 1), "completed")
	pc_screen.set_visible(true)
