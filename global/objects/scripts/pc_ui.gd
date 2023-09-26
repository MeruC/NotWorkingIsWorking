extends CanvasLayer

onready var io = $io
onready var pc_screen = $pc_screen
onready var camera = $"../interaction_area/Camera"
onready var camera_2 = $"../interaction_area/Camera2"

func _on_Exit_pressed():
	get_parent().get_node("interaction_area").out_of_range()


func _on_to_io_pressed():
	pc_screen.set_visible(false)
	yield(CameraTransition.transition_camera3D(camera, camera_2, 1), "completed")
	io.set_visible(true)


func _on_to_pc_pressed():
	io.set_visible(false)
	yield(CameraTransition.transition_camera3D(camera_2, camera, 1), "completed")
	pc_screen.set_visible(true)
