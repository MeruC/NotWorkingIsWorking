extends Spatial

var player
onready var mobile_controls = $"%mobile_controls"
onready var inventory = $"%inventory"


var joystick
export (Resource) var setting_data
var onMenu = false
#var lesson = preload("res://offline_levels/level1/level1_discussion/level1_discussion.tscn")

func _ready():
	if get_parent().name != "editor":
		inventory.set_visible(true)
		mobile_controls.set_visible(true)
		if setting_data.gender == "male":
			player = preload("res://global/player/player.tscn")
			add_child(player.instance())
			Global.playerCamera = get_node("Player/Camera/Camera")
			Global.playerCamera.current = true
			Global.playerCameraTop = get_node("Player/Camera/CameraTop")
			Global.player = get_node("Player")
			Global.player.current_level = self
		elif setting_data.gender == "female":
			player = preload("res://global/player_girl/player-girl.tscn")
			add_child(player.instance())
			Global.playerCamera = get_node("Player/Camera/Camera")
			Global.playerCamera.current = true
			Global.playerCameraTop = get_node("Player/Camera/CameraTop")
			Global.player = get_node("Player")
			Global.player.current_level = self
			print(self)
		
		
	SignalManager.connect( "pc_opened", self, "_on_pc_opened" )
	SignalManager.connect( "pc_closed", self, "_on_pc_closed" )
	SignalManager.connect( "cable_used", self, "_on_cable_used" )
	SignalManager.connect( "cable_done", self, "_on_cable_done" )

func _on_pc_opened():
	#player = main.get_node("Player")
	inventory.set_visible(false)
	mobile_controls.set_visible(false)
	onMenu = true
	Global.playerCanMove = false
	
func _on_pc_closed():
	#player = main.get_node("Player")
	inventory.set_visible(true)
	mobile_controls.set_visible(true)
	if (onMenu):
		yield(CameraTransition.transition_camera3D(get_viewport().get_camera(), Global.playerCamera , 1), "completed")
		Global.player.get_node("Pivot").set_visible(true)
		onMenu = false
		Global.playerCanMove = true
		Global.playerInteractLbl.set_visible(true)
		
func _on_cable_used():
	inventory.ui_container.set_visible(false)

func _on_cable_done():
	inventory.ui_container.set_visible(true)
