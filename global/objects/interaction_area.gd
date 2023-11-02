class_name Router extends Area

export( String ) var pc_name
export( NodePath ) onready var ui = get_node( ui ) as CanvasLayer
onready var io = $"../ui/io"
#onready var pc_screen = $"../ui/pc_screen"
#onready var power = $"../CollisionShape2D/CSGMesh/CSGBox"

var inventory : Inventory
var action = "open"
var object_name = "Chest"
var previousCam : Camera

func _ready():
	object_name = pc_name
	
func interact():
	Global.playerInteractLbl.set_visible(false)
	SignalManager.emit_signal( "router_open")
	Global.player.get_node("Pivot").set_visible(false)
	yield(CameraTransition.transition_camera3D(Global.playerCamera, get_node("Camera"), 1), "completed")
	ui.set_visible(true)
	#var mats = power.get_material()
	#mats.albedo_color = Color(0, 255, 0)
	#power.set_material(mats)

func out_of_range():
	#var mats = power.get_material()
	#mats.albedo_color = Color(255, 0, 0)
	#power.set_material(mats)
	#pc_screen.set_visible(true)
	ui.set_visible(false)
	SignalManager.emit_signal( "router_close")
	yield(get_tree().create_timer(2.0), "timeout")
	
	#io.set_visible(false)
