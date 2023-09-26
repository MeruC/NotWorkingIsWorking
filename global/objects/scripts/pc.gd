class_name Tower_PC extends Area

export( String ) var pc_name
export( NodePath ) onready var ui = get_node( ui ) as CanvasLayer

var inventory : Inventory
var action = "open"
var object_name = "Chest"
var previousCam : Camera

func _ready():
	object_name = pc_name

func interact():
	SignalManager.emit_signal( "pc_opened")
	yield(CameraTransition.transition_camera3D(Global.playerCamera, get_node("Camera"), 2), "completed")
	ui.set_visible(true)

func out_of_range():
	ui.set_visible(false)
	SignalManager.emit_signal( "pc_closed")
	
