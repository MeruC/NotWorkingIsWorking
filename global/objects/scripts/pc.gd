class_name Tower_PC extends Area

export( String ) var pc_name
export( NodePath ) onready var ui = get_node( ui ) as CanvasLayer
onready var io = $"../ui/io"
onready var pc_screen = $"../ui/pc_screen"
onready var power = $"../CollisionShape2D/CSGMesh/CSGBox"

var inventory : Inventory
var action = "open"
var object_name = "Chest"
var previousCam : Camera

func _ready():
	object_name = pc_name

func interact():
	Global.playerInteractLbl.set_visible(false)
	SignalManager.emit_signal( "pc_opened")
	Global.player.get_child(0).set_visible(false)
	yield(CameraTransition.transition_camera3D(Global.playerCamera, get_node("Camera"), 1), "completed")
	ui.set_visible(true)
	var mats = power.get_material()
	mats.albedo_color = Color(0, 255, 0)
	power.set_material(mats)

func out_of_range():
	var mats = power.get_material()
	mats.albedo_color = Color(255, 0, 0)
	power.set_material(mats)
	ui.set_visible(false)
	io.set_visible(false)
	pc_screen.set_visible(true)
	SignalManager.emit_signal( "pc_closed")
	
