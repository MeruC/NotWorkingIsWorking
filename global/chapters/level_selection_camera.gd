extends Camera

var maxLimit = Vector3(20, 0, 34)
var minLimit = Vector3(-4.42804, 0, 6.40031)
var swipeThreshold = 50.0
export (float, 1.0, 1.5) var MAX_DIAGONAL_SLOPE = 1.3
var level2_position = Vector3(17.258677, 0, 22.683001)
var reachlevel2 = false

onready var level1 = $"../level1"
onready var level2 = $"../level2"
export var max_speed = 10
export var friction = 100 # Replace with your desired position
var showDistanceThreshold = 1.0  # Adjust as needed

# Swipe Gesture Detection
var swipe_start_position = Vector2()  # Declare swipe_start_position as a member variable
var swipe_direction = Vector3.ZERO  # Store swipe direction as a member variable

func _ready():
	pass

func _process(delta: float) -> void:
	if reachlevel2:
		return

	var direction = get_swipe_direction()
	apply_friction(direction, delta)
	apply_movement(direction, delta)
	var cameraTransform = global_transform
	var newCameraPosition = cameraTransform.origin + swipe_direction * max_speed * delta

	# Check if the new position is within the bounds
	if is_within_bounds(newCameraPosition):
		# Update the camera's position
		cameraTransform.origin = newCameraPosition
		global_transform = cameraTransform
		
	#position of every level
	var targetlevel1 = Vector3(-4.42804, 9.84598, 6.40031) 
	var targetlevel2 = Vector3(0,0,0)
	
	var cameraPosition = cameraTransform.origin
	var distanceTolevel1 = cameraPosition.distance_to(targetlevel1)
	var distantTolevel2 = cameraPosition.distance_to(level2_position)

	if distanceTolevel1 < showDistanceThreshold:
		level1.visible = true
		
	elif distantTolevel2 < showDistanceThreshold:
		# Show the label when close to level2_position
		level1.visible = true
		reachlevel2 = true
	else:
		# Hide the label when not close to either position
		reachlevel2 = false
		level1.visible = false

# Swipe Gesture Detection
func _input(event):
	if not event is InputEventScreenTouch:
		return
	if event.pressed:
		_start_detection(event.position)
	else:
		_end_detection(event.position)

func _start_detection(position):
	swipe_start_position = position

func _end_detection(position):
	var direction = (position - swipe_start_position).normalized()
	var swipeDistance = (position - swipe_start_position).length()

	if swipeDistance < swipeThreshold:
		return

	if abs(direction.x) + abs(direction.y) >= MAX_DIAGONAL_SLOPE:
		swipe_direction = Vector3.ZERO
	else:
		if abs(direction.x) > abs(direction.y):
			swipe_direction = Vector3(-sign(direction.x), 0.0, 0.0)
		else:
			swipe_direction = Vector3(0.0, 0.0, -sign(direction.y))

# Getting the Camera Facing Direction
func get_swipe_direction() -> Vector3:
	return swipe_direction

func apply_movement(direction, delta):
	if swipe_direction != Vector3.ZERO:
		# Calculate the potential new position based on the swipe direction
		var new_position = global_transform.origin + swipe_direction * max_speed * delta

		# Check if the new position is within the bounds
		if is_within_bounds(new_position):
			# Update the camera's position
			global_transform.origin = new_position

# Friction Physics
func apply_friction(direction, delta):
	if direction == Vector3.ZERO:
		swipe_direction = Vector3.ZERO
		
func is_within_bounds(position):
	return (
		position.x >= minLimit.x and position.x <= maxLimit.x and
		position.z >= minLimit.z and position.z <= maxLimit.z
	)
	swipe_direction = Vector3.ZERO

