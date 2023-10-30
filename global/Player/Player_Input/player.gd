extends KinematicBody

#something
export( NodePath ) onready var label = get_node( label ) as VBoxContainer
export( NodePath ) onready var preview_parent = get_node(preview_parent) as Spatial
export( NodePath ) onready var no_sign = get_node(no_sign) as StaticBody
export( NodePath ) onready var place = get_node(place) as StaticBody
export( Resource ) var settings_data
onready var tween = $"%Tween"


var current_level : Spatial
var object_point
var cabletype

#NodeReferences
onready var camera = $"%Camera"
onready var player: KinematicBody = $"."
onready var pivot = $"%Pivot"

export var max_speed = 10
export var acceleration = 70
export var friction = 60
var velocity := Vector3.ZERO

var start_pos = Vector3(0, .5, 0)

var is_moving = false
var mode = "normal"

var object_number = 0
var previous_object = ""

onready var walk_animation = $AnimationPlayer

onready var idle = $Pivot/CSGSphere
onready var walk = $Pivot/walk
var cam = 0

export( NodePath ) onready var interact_zone = get_node( interact_zone ) as Area
export( NodePath ) onready var interact_labels = get_node( interact_labels ) as Control

export( NodePath ) onready var camera_normal = get_node( camera_normal ) as Camera
export( NodePath ) onready var camera_top = get_node( camera_top ) as Camera

var current_interactable

var object_point2
var cursor_pos := Vector3.ZERO

var inventory

func _ready():
	
	current_level = get_parent()
	print(inventory)
	
	print("Current Level: " + str(current_level))
	
	if settings_data.gender == "female":
		
		if settings_data.costume == "girl_pants":
			$Pivot/CSGSphere.mesh = preload("res://resources/Models/Character skin girl/default_pants/idle/idle.obj")
			$Pivot/CSGSphere.material_override =  preload("res://resources/Models/Character skin girl/default_pants/idle/idle.png")
			#1
			$"Pivot/walk/1".mesh = preload("res://resources/Models/Character skin girl/default_pants/walk/1.obj")
			$"Pivot/walk/1".material_override = preload("res://resources/Models/Character skin girl/default_pants/walk/1.png")
			#2
			$"Pivot/walk/2".mesh = preload("res://resources/Models/Character skin girl/default_pants/idle/idle.obj")
			$"Pivot/walk/2".material_override = preload("res://resources/Models/Character skin girl/default_pants/idle/idle.png")
			#3
			$"Pivot/walk/3".mesh = preload("res://resources/Models/Character skin girl/default_pants/walk/2.obj")
			$"Pivot/walk/3".material_override = preload("res://resources/Models/Character skin boy/cict_shirt/walk/2.png")
			#4
			$"Pivot/walk/4".mesh = preload("res://resources/Models/Character skin girl/default_pants/idle/idle.obj")
			$"Pivot/walk/4".material_override = preload("res://resources/Models/Character skin girl/default_pants/idle/idle.png")
			
		if settings_data.costume == "girl_casual":
			$Pivot/CSGSphere.mesh = preload("res://resources/Models/Character skin girl/casual_attire/idle/idle.obj")
			$Pivot/CSGSphere.material_override =  preload("res://resources/Models/Character skin girl/casual_attire/idle/idle.png")
			#1
			$"Pivot/walk/1".mesh = preload("res://resources/Models/Character skin girl/casual_attire/walk/1.obj")
			$"Pivot/walk/1".material_override = preload("res://resources/Models/Character skin girl/casual_attire/walk/1.png")
			#2
			$"Pivot/walk/2".mesh = preload("res://resources/Models/Character skin girl/casual_attire/idle/idle.obj")
			$"Pivot/walk/2".material_override = preload("res://resources/Models/Character skin girl/casual_attire/idle/idle.png")
			#3
			$"Pivot/walk/3".mesh = preload("res://resources/Models/Character skin girl/casual_attire/walk/2.obj")
			$"Pivot/walk/3".material_override = preload("res://resources/Models/Character skin girl/casual_attire/walk/2.png")
			#4
			$"Pivot/walk/4".mesh = preload("res://resources/Models/Character skin girl/casual_attire/idle/idle.obj")
			$"Pivot/walk/4".material_override = preload("res://resources/Models/Character skin girl/casual_attire/idle/idle.png")
			
		if settings_data.costume == "female":
			$Pivot/CSGSphere.mesh = preload("res://resources/Models/Player -girl/idle/idle- Girl.obj")
			$Pivot/CSGSphere.material_override =  preload("res://resources/Models/Player -girl/idle/idle- Girl.png")
		
		else:
			
			pass
	if settings_data.gender == "male":
		
		if settings_data.costume == "male":
			$Pivot/CSGSphere.mesh = preload("res://resources/Models/Player/Idle/1.obj")
			$Pivot/CSGSphere.material_override =  preload("res://resources/Models/Player/1.png")
			
		if settings_data.costume == "blue_shirt":
			$Pivot/CSGSphere.mesh = preload("res://resources/Models/Character skin boy/blue_shirt/idle/idle.obj")
			$Pivot/CSGSphere.material_override =  preload("res://resources/Models/Character skin boy/blue_shirt/idle/idle.png")
			#1
			$"Pivot/walk/1".mesh = preload("res://resources/Models/Character skin boy/blue_shirt/walk/1.obj")
			$"Pivot/walk/1".material_override = preload("res://resources/Models/Character skin boy/blue_shirt/walk/1.png")
			#2
			$"Pivot/walk/2".mesh = preload("res://resources/Models/Character skin boy/blue_shirt/idle/idle.obj")
			$"Pivot/walk/2".material_override = preload("res://resources/Models/Character skin boy/blue_shirt/idle/idle.png")
			#3
			$"Pivot/walk/3".mesh = preload("res://resources/Models/Character skin boy/blue_shirt/walk/2.obj")
			$"Pivot/walk/3".material_override = preload("res://resources/Models/Character skin boy/blue_shirt/walk/2.png")
			#4
			$"Pivot/walk/4".mesh = preload("res://resources/Models/Character skin boy/blue_shirt/idle/idle.obj")
			$"Pivot/walk/4".material_override = preload("res://resources/Models/Character skin boy/blue_shirt/idle/idle.png")
			
		if settings_data.costume == "cict_shirt":
			$Pivot/CSGSphere.mesh = preload("res://resources/Models/Character skin boy/cict_shirt/idle/idle.obj")
			$Pivot/CSGSphere.material_override =  preload("res://resources/Models/Character skin boy/cict_shirt/idle/idle.png")
			#1
			$"Pivot/walk/1".mesh = preload("res://resources/Models/Character skin boy/cict_shirt/walk/1.obj")
			$"Pivot/walk/1".material_override = preload("res://resources/Models/Character skin boy/cict_shirt/walk/1.png")
			#2
			$"Pivot/walk/2".mesh = preload("res://resources/Models/Character skin boy/cict_shirt/idle/idle.obj")
			$"Pivot/walk/2".material_override = preload("res://resources/Models/Character skin boy/cict_shirt/idle/idle.png")
			#3
			$"Pivot/walk/3".mesh = preload("res://resources/Models/Character skin boy/cict_shirt/walk/2.obj")
			$"Pivot/walk/3".material_override = preload("res://resources/Models/Character skin boy/cict_shirt/walk/2.png")
			#4
			$"Pivot/walk/4".mesh = preload("res://resources/Models/Character skin boy/cict_shirt/idle/idle.obj")
			$"Pivot/walk/4".material_override = preload("res://resources/Models/Character skin boy/cict_shirt/idle/idle.png")
			
		if settings_data.costume == "formal_attire":
			$Pivot/CSGSphere.mesh = preload("res://resources/Models/Character skin boy/formal_attire/idle/idle.obj")
			$Pivot/CSGSphere.material_override =  preload("res://resources/Models/Character skin boy/formal_attire/idle/idle.png")
			#1
			$"Pivot/walk/1".mesh = preload("res://resources/Models/Character skin boy/formal_attire/walk/1.obj")
			$"Pivot/walk/1".material_override = preload("res://resources/Models/Character skin boy/formal_attire/walk/1.png")
			#2
			$"Pivot/walk/2".mesh = preload("res://resources/Models/Character skin boy/formal_attire/idle/idle.obj")
			$"Pivot/walk/2".material_override = preload("res://resources/Models/Character skin boy/formal_attire/idle/idle.png")
			#3
			$"Pivot/walk/3".mesh = preload("res://resources/Models/Character skin boy/formal_attire/walk/2.obj")
			$"Pivot/walk/3".material_override = preload("res://resources/Models/Character skin boy/formal_attire/walk/2.png")
			#4
			$"Pivot/walk/4".mesh = preload("res://resources/Models/Character skin boy/formal_attire/idle/idle.obj")
			$"Pivot/walk/4".material_override = preload("res://resources/Models/Character skin boy/formal_attire/idle/idle.png")
			
		if settings_data.costume == "orange_shirt":
			$Pivot/CSGSphere.mesh = preload("res://resources/Models/Character skin boy/orange_shirt/idle/idle.obj")
			$Pivot/CSGSphere.material_override =  preload("res://resources/Models/Character skin boy/orange_shirt/idle/idle.png")
			#1
			$"Pivot/walk/1".mesh = preload("res://resources/Models/Character skin boy/orange_shirt/walk/1.obj")
			$"Pivot/walk/1".material_override = preload("res://resources/Models/Character skin boy/orange_shirt/walk/1.png")
			#2
			$"Pivot/walk/2".mesh = preload("res://resources/Models/Character skin boy/orange_shirt/idle/idle.obj")
			$"Pivot/walk/2".material_override = preload("res://resources/Models/Character skin boy/orange_shirt/idle/idle.png")
			#3
			$"Pivot/walk/3".mesh = preload("res://resources/Models/Character skin boy/orange_shirt/walk/2.obj")
			$"Pivot/walk/3".material_override = preload("res://resources/Models/Character skin boy/orange_shirt/walk/2.png")
			#4
			$"Pivot/walk/4".mesh = preload("res://resources/Models/Character skin boy/orange_shirt/idle/idle.obj")
			$"Pivot/walk/4".material_override = preload("res://resources/Models/Character skin boy/orange_shirt/idle/idle.png")
			
	Global.playerInteractLbl = get_node("interact")

func _physics_process(delta: float) -> void:
	if (Global.playerCanMove):
		var input_vector = get_input_vector()
		var direction = get_direction(input_vector)
		apply_friction(direction, delta)
		apply_movement(input_vector, direction, delta)
		velocity = move_and_slide(velocity, Vector3.UP)
	
func _process(delta):
	object_point2 = WhatObject()
	
	if LevelGlobal.on_cable_mode:
		var selected = current_level.get_node(object_point2.collider.name)
		match(object_number):
			0:
				if("object_monitor" in object_point2.collider.name):
					if selected.fe0 == null:
						previewCursor()
						place.set_visible(true)
						no_sign.set_visible(false)
					else:
						previewCursor()
						place.set_visible(false)
						no_sign.set_visible(true)
				else:
					previewCursor()
					place.set_visible(false)
					no_sign.set_visible(true)
			1:
				match(object_point2.collider.name):
					previous_object:
						previewCursor()
						place.set_visible(false)
						no_sign.set_visible(true)
					_:
						if("object_monitor" in object_point2.collider.name):
							if selected.fe0 == null:
								previewCursor()
								place.set_visible(true)
								no_sign.set_visible(false)
							else:
								previewCursor()
								place.set_visible(false)
								no_sign.set_visible(true)
						else:
							previewCursor()
							place.set_visible(false)
							no_sign.set_visible(true)
					
	
	if velocity.x == 0 and velocity.z == 0:
		idle.set_visible(true)
		walk.set_visible(false)
		walk.global_translation.y = 1
		walk_animation.current_animation = "RESET"
	else:
		idle.set_visible(false)
		walk.set_visible(true)	
		walk_animation.current_animation = "player_walk"
		
	if not current_interactable:
		var overlapping_area = interact_zone.get_overlapping_areas()
		
		if overlapping_area.size() > 0 and overlapping_area[ 0 ].has_method("interact"):
			current_interactable = overlapping_area[ 0 ]
			interact_labels.display(current_interactable)


#Getting The Input
func get_input_vector():
	var input_vector := Vector3.ZERO
	input_vector.x = Input.get_action_strength("right") - Input.get_action_strength("left")
	input_vector.z = Input.get_action_strength("down") - Input.get_action_strength("up")
	return input_vector.normalized() if input_vector.length() > 1 else input_vector

#Getting the Camera Facing Direction
func get_direction(input_vector):
	var direction = (input_vector.x * camera.transform.basis.x) + (input_vector.z * camera.transform.basis.z)
	return direction
	
#Actually Moving the Player
func apply_movement(input_vector, direction, delta):
	if direction != Vector3.ZERO:
		velocity.x = velocity.move_toward(direction * max_speed, acceleration * delta).x
		velocity.z = velocity.move_toward(direction * max_speed, acceleration * delta).z
		pivot.look_at(global_transform.origin + direction, Vector3.UP)

#Friction Physics
func apply_friction(direction, delta):
	if direction == Vector3.ZERO:
		velocity = velocity.move_toward(Vector3.ZERO, friction * delta)
		

func _on_Player_visibility_changed():
	player.global_translation = start_pos
	pass # Replace with function body.

#Interactions
func _input( event ):
		
	cursor_pos = Vector3(ScrenPointToRay())
	cursor_pos.y = 0
	
	#This Snaps the Objects Position to a grid
	cursor_pos.x = stepify(cursor_pos.x, 2)
	cursor_pos.z = stepify(cursor_pos.z, 2)
	object_point = WhatObject()
	if Input.is_action_just_pressed("cam_test"):
		match cam:
			0:
				CameraTransition.transition_camera3D(Global.playerCamera, Global.playerCameraTop, 1)
				cam = 1
			1:
				CameraTransition.transition_camera3D(Global.playerCameraTop, Global.playerCamera, 1)
				cam = 0
	if event.is_action_pressed("interact") and current_interactable:
		pivot.set_visible(false)
		current_interactable.interact()
		
	if mode == "cable":
		print(cabletype)
		if cabletype == "Console_Cable":
			pass
		elif cabletype == "crossover" or cabletype == "straight_through":
			if event is InputEventScreenTouch and OS.get_name() == "Android":
				pass
			if event is InputEventMouseButton and event.is_pressed() and Global.curOS != "Android":
				if ("object_monitor" in object_point.collider.name):
					var selected = current_level.get_node(object_point.collider.name)
					match object_number:
						0:
							print(selected.test)
							if selected.fe0 == null:
								print(selected.device_name)
								previous_object = object_point.collider.name
								LevelGlobal.object_hold = selected
								object_number = 1
								print("Select a different device")
						1:
							if (LevelGlobal.object_hold == selected):
								print("Select a different device")
							else:
								if selected.fe0 == null:
									selected._set_connector(LevelGlobal.object_hold, cabletype)
									LevelGlobal.object_hold._set_connector(selected, cabletype)
									object_number = 0
									_on_cable_connected()
		
							

func _on_InteractionArea_area_exited(area):
	if current_interactable == area:
		if current_interactable.has_method( "out_of_range" ):
			current_interactable.out_of_range()
		
		interact_labels.hide()
		current_interactable = null

func _on_cable_used( type ):
	cabletype = type
	label.modulate = Color8(255,255,255,0)
	yield(CameraTransition.transition_camera3D(camera_normal, camera_top, 1), "completed")
	camera.c_rot = Vector3(0,0,0)
	camera.rotation_degrees.y = 0
	mode = "cable"
	preview_parent.set_visible(true)
	SignalManager.emit_signal("cable_used")
	LevelGlobal.on_cable_mode = true
	
func _on_cable_connected():
	label.modulate = Color8(255,255,255,255)
	mode = "normal"
	preview_parent.set_visible(false)
	LevelGlobal.on_cable_mode = false
	yield(CameraTransition.transition_camera3D(camera_top, camera_normal, 1), "completed")
	SignalManager.emit_signal("cable_done")

func previewCursor():
	if(object_point2.has("position")):
		preview_parent.global_translation = cursor_pos
		preview_parent.global_translation.y = 10.0
		no_sign.global_translation = cursor_pos
		no_sign.global_translation.y = 10.0
		
#Fires a ray to check for cursor 3D location
func ScrenPointToRay():
	var spaceState = get_world().direct_space_state
	var mousePos = get_viewport().get_mouse_position()
	var camera = get_tree().root.get_camera()
	var rayOrigin = camera.project_ray_origin(mousePos)
	var rayEnd = rayOrigin + camera.project_ray_normal(mousePos) * 2000
	var rayArray = spaceState.intersect_ray(rayOrigin, rayEnd)
	if rayArray.has("position"):
		return rayArray["position"]
	return Vector3()
		
func WhatObject():
	var spaceState = get_world().direct_space_state
	
	var mousePos = get_viewport().get_mouse_position()
	var camera = get_tree().root.get_camera()
	var rayOrigin = camera.project_ray_origin(mousePos)
	var rayEnd = rayOrigin + camera.project_ray_normal(mousePos) * 2000
	var rayArray = spaceState.intersect_ray(rayOrigin, rayEnd)
	return rayArray
