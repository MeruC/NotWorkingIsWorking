extends Control

export( NodePath ) onready var main = get_node(main) as Spatial
export( NodePath ) onready var current = get_node(current) as Label

var player
export( NodePath ) onready var ui = get_node(ui) as CanvasLayer
var inventory
var mobile_controls
var joystick
var task_ui
var level
onready var joystick_editor = $"%joystickEditor"
export( NodePath ) onready var previews = get_node(previews) as Spatial
export( NodePath ) onready var no_sign = get_node(no_sign) as StaticBody
export( NodePath ) onready var item_select = get_node(item_select) as Control
export( NodePath ) onready var other_ui = get_node(other_ui) as Control
export( NodePath ) onready var verify_ui = get_node(verify_ui) as Control
onready var mode_menu = $modeMenu
onready var menu_animations = $"%MenuAnimations"


var playerSpawn = preload("res://global/player/player.tscn")
var last_mode = "place"

func _ready():
	Global.editor_mode = "place"
	current.text = "Current Mode: Place"
	main.get_node("level/mobile_controls/joystick").use_input_actions = false
	SignalManager.connect( "confirm", self, "_on_confirm_pressed" )
	
func _on_confirm_pressed(action):
	match(action):
		"verify":
			inventory = main.get_node("level/inventory")
			mobile_controls = main.get_node("level/mobile_controls")
			joystick = main.get_node("level/mobile_controls/joystick")
			task_ui =  main.get_node("level/tasks_ui")
			level = main.get_node("level")
			if(Global.editor_mode != "play"):
				level.reset_level()
				#Spawning Player
				var new_item = playerSpawn.instance() 
				main.add_child(new_item)
				new_item.owner = main
				player = main.get_node("Player")
				Global.player = player
				Global.playerCamera = main.get_node("Player/Camera/Camera")
				Global.playerCamera.current = true
				Global.playerCanMove = true
				print(Global.playerInteractLbl)
				#Changing Camera
				CameraTransition.transition_camera3D(main.get_node("Editor_Camera/Camera"), main.get_node("Player/Camera/Camera"), 1.5)
				#yield(get_tree().create_timer(1),"timeout")
				#Editor Mode
				last_mode = Global.editor_mode
				Global.editor_mode = "play"
				
				#Changing UI
				previews.set_visible(false)
				no_sign.set_visible(false)
				ui.set_visible(false)
				joystick_editor.use_input_actions = false
				yield(get_tree().create_timer(1.5),"timeout")
				inventory.set_visible(true)
				mobile_controls.set_visible(true)
				joystick.use_input_actions = true
				other_ui.set_visible(true)
				task_ui.set_visible(true)
				verify_ui.set_visible(true)
				

func _on_modes_mouse_entered():
	Global.can_place = false
	#print(Global.can_place)


func _on_modes_mouse_exited():
	Global.can_place = true
	print(Global.can_place)

func _process(delta):
	match (Global.editor_mode):
		"place":
			current.text = "Current Mode: Place"
		"rotate":
			current.text = "Current Mode: Rotate"
		"remove":
			current.text = "Current Mode: Remove"
		_:
			current.text = "Current Mode: Play"


func _on_place_pressed():
	Global.editor_mode = "place"
	item_select.set_visible(true)
	yield(get_tree().create_timer(0.2),"timeout")
	Global.can_place = true
	mode_menu.text = "Place"
	mode_menu.pressed = false
	menu_animations.play_backwards("mode")


func _on_rotate_pressed():
	Global.editor_mode = "rotate"
	item_select.set_visible(false)
	mode_menu.text = "Rotate"
	mode_menu.pressed = false
	menu_animations.play_backwards("mode")


func _on_remove_pressed():
	Global.editor_mode = "remove"
	item_select.set_visible(false)
	mode_menu.text = "Remove"
	mode_menu.pressed = false
	menu_animations.play_backwards("mode")

func _on_play_pressed():
	joystick_editor.use_input_actions = true
	joystick_editor.set_visible(true)
	$"../file/menu".pressed = false
	$"%MenuAnimations".play_backwards("menu")
	inventory = main.get_node("level/inventory")
	mobile_controls = main.get_node("level/mobile_controls")
	joystick = main.get_node("level/mobile_controls/joystick")
	task_ui =  main.get_node("level/tasks_ui")
	level = main.get_node("level")
	if(Global.editor_mode != "play"):
		level.reset_level()
		#Spawning Player
		var new_item = playerSpawn.instance() 
		main.add_child(new_item)
		new_item.owner = main
		player = main.get_node("Player")
		Global.player = player
		Global.playerCamera = main.get_node("Player/Camera/Camera")
		Global.playerCamera.current = true
		Global.playerCanMove = true
		print(Global.playerInteractLbl)
		#Changing Camera
		CameraTransition.transition_camera3D(main.get_node("Editor_Camera/Camera"), main.get_node("Player/Camera/Camera"), 1.5)
		#yield(get_tree().create_timer(1),"timeout")
		#Editor Mode
		last_mode = Global.editor_mode
		Global.editor_mode = "play"
		
		#Changing UI
		previews.set_visible(false)
		no_sign.set_visible(false)
		ui.set_visible(false)
		joystick_editor.use_input_actions = false
		yield(get_tree().create_timer(1.5),"timeout")
		inventory.set_visible(true)
		mobile_controls.set_visible(true)
		joystick.use_input_actions = true
		other_ui.set_visible(true)
		task_ui.set_visible(true)
	elif(Global.editor_mode == "play"):
		
		#Changing Camera
		CameraTransition.transition_camera3D(main.get_node("Player/Camera/Camera"), main.get_node("Editor_Camera/Camera"), 1.5)
		#Deleting player
		main.remove_child(player)
		player.queue_free()
		
		#Editor Mode
		Global.editor_mode = last_mode
		
		#Changing UI
		verify_ui.set_visible(false)
		other_ui.set_visible(false)
		inventory.set_visible(false)
		mobile_controls.set_visible(false)
		joystick.use_input_actions = false
		task_ui.set_visible(false)
		yield(get_tree().create_timer(1.5),"timeout")
		ui.set_visible(true)
		joystick_editor.use_input_actions = true
		previews.set_visible(true)
		no_sign.set_visible(true)
		


func _on_select_pressed():
	Global.editor_mode = "select"
	item_select.set_visible(false)
	mode_menu.text = "Select"
	mode_menu.pressed = false
	menu_animations.play_backwards("mode")
	
func _on_uploadVerify():
	joystick_editor.use_input_actions = true
	joystick_editor.set_visible(true)
	$"../file/menu".pressed = false
	$"%MenuAnimations".play_backwards("menu")
	level = get_node("/root/editor/level")
	if level.saved:
		$"../../../verify_ui/upload".disabled = true
		ConfirmDialog.mode = "Confirm Dialog"
		ConfirmDialog._ready()
		ConfirmDialog.set_visible(true)
		ConfirmDialog.confirm_animation.play("intro")
		ConfirmDialog.label.text = "Complete the level first to upload it!"
		ConfirmDialog.action = "verify"
	else:
		$"../../../verify_ui/upload".disabled = true
		ConfirmDialog.mode = "OK Dialog"
		ConfirmDialog._ready()
		ConfirmDialog.set_visible(true)
		ConfirmDialog.confirm_animation.play("intro")
		ConfirmDialog.label.text = "Save the level first before uploading!"
		ConfirmDialog.action = "null"
