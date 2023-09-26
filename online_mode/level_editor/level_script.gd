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
		elif setting_data.gender == "female":
			player = preload("res://global/Player_girl/player-girl.tscn")
			add_child(player.instance())
			Global.playerCamera = get_node("Player/Camera/Camera")
			Global.playerCamera.current = true
		
		
	SignalManager.connect( "pc_opened", self, "_on_pc_opened" )
	SignalManager.connect( "pc_closed", self, "_on_pc_closed" )

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
		CameraTransition.transition_camera3D(get_viewport().get_camera(), Global.playerCamera , 2)
		onMenu = false
		Global.playerCanMove = true
