extends Spatial

var player
onready var mobile_controls = $"%mobile_controls"
onready var inventory = $"%inventory"
onready var tasks_ui = $"%tasks_ui"
onready var task_manager = $tasks_ui/task_manager


var joystick
export (Resource) var setting_data
var onMenu = false
#var lesson = preload("res://offline_levels/level1/level1_discussion/level1_discussion.tscn")


var nodes : Array = []
func get_all_monitor(node) -> Array:
	for N in node.get_children():
		#print(N)
		if "object_monitor" in N.name:
			nodes.append(N)
	return nodes
	
func check_ip(ip, subnetmask):
	for N in nodes:
		if (N.ipv4_address == ip) and (N.subnet_mask == subnetmask):
			print("pass")
			

func _ready():
	get_all_monitor(self)
	check_ip("0.0.0.0", "0.0.0.0")
	
	LevelGlobal.object_hold = null
	if get_parent().name != "editor":
		inventory.set_visible(true)
		mobile_controls.set_visible(true)
		if setting_data.gender == "male":
			player = preload("res://global/player/player.tscn")
			add_child(player.instance())
			Global.playerCamera = get_node("Player/Camera/Camera")
			Global.playerCamera.current = true
			Global.playerCameraTop = get_node("Player/CameraTop")
			Global.player = get_node("Player")
			Global.player.current_level = self
		elif setting_data.gender == "female":
			print("Hello")
			player = preload("res://global/player_girl/player-girl.tscn")
			add_child(player.instance())
			Global.playerCamera = get_node("Player/Camera/Camera")
			Global.playerCamera.current = true
			Global.playerCameraTop = get_node("Player/CameraTop")
			Global.player = get_node("Player")
			Global.player.current_level = self
		
		
	SignalManager.connect( "pc_opened", self, "_on_pc_opened" )
	SignalManager.connect( "pc_closed", self, "_on_pc_closed" )
	SignalManager.connect( "cable_used", self, "_on_cable_used" )
	SignalManager.connect( "cable_done", self, "_on_cable_done" )
	SignalManager.connect( "router_open", self, "_on_router_open" )
	SignalManager.connect( "router_close", self, "_on_router_close" )

func _on_pc_opened():
	#player = main.get_node("Player")
	inventory.set_visible(false)
	mobile_controls.set_visible(false)
	onMenu = true
	Global.playerCanMove = false
	task_manager.visible = false
	
func _on_pc_closed():
	#player = main.get_node("Player")
	if (onMenu):
		yield(CameraTransition.transition_camera3D(get_viewport().get_camera(), Global.playerCamera , 1), "completed")
		Global.player.get_node("Pivot").set_visible(true)
		onMenu = false
		Global.playerCanMove = true
		Global.playerInteractLbl.set_visible(true)
		inventory.set_visible(true)
		mobile_controls.set_visible(true)
		task_manager.visible = true
		
		
func _on_router_open():
	#player = main.get_node("Player")
	inventory.set_visible(false)
	mobile_controls.set_visible(false)
	onMenu = true
	Global.playerCanMove = false
	task_manager.visible = false
	
func _on_router_close():
	#player = main.get_node("Player")
	if (onMenu):
		yield(CameraTransition.transition_camera3D(get_viewport().get_camera(), Global.playerCamera , 1), "completed")
		Global.player.get_node("Pivot").set_visible(true)
		onMenu = false
		Global.playerCanMove = true
		Global.playerInteractLbl.set_visible(true)
		inventory.set_visible(true)
		mobile_controls.set_visible(true)
		task_manager.visible = true
		
		
func _on_cable_used():
	inventory.ui_container.set_visible(false)
	mobile_controls.buttons.set_visible(false)
	mobile_controls.cable_ui.set_visible(true)

func _on_cable_done():
	inventory.ui_container.set_visible(true)
	mobile_controls.buttons.set_visible(true)
	#mobile_controls.cable_ui.set_visible(false)
	

