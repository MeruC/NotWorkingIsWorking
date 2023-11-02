extends Spatial

onready var camera = $"%Camera"
onready var camera_main = $"%CameraMain"
onready var tap = $"../tap"
onready var tap_screen = $"../tap_screen"
onready var colorbottom = $"../Control2/colorbottom"
onready var colortop = $"../Control/colortop"

export (Resource) var setting_data
var player
#onready var player = $Player


func _ready():
	Global.playerCanMove = false
	if setting_data.gender == "male":
		player = preload("res://global/Player/player.tscn")
		add_child(player.instance())
		Global.playerCamera = get_node("Player/Camera/Camera")
		#Global.playerCamera.current = true
		Global.player = get_node("Player")
		colortop.color = Color8(0, 175, 255, 255)
		colorbottom.color = Color8(0, 175, 255, 255)
	elif setting_data.gender == "female":
		player = preload("res://global/player_girl/player-girl.tscn")
		add_child(player.instance())
		Global.playerCamera = get_node("Player/Camera/Camera")
		#Global.playerCamera.current = true
		Global.player = get_node("Player")
		colortop.color = Color8(255, 100, 150, 255)
		colorbottom.color = Color8(255, 100, 150, 255)
		
	Global.player.translation = Vector3(-3.793, 1.445, 16.505)
	Global.player.rotation = Vector3(0, 0, 0)
	camera.current = true
	
	TransitionNode.animation_player.play("in")
	yield(CameraTransitionDefault.transition_camera3D(camera, camera_main, 4), "completed")
	tap.set_visible(true)
	tap_screen.play("intro")
