extends Camera

var maxLimit = Vector3(20, 0, 34)
var minLimit = Vector3(-4.42804, 0, 6.40031)
var swipeThreshold = 100.0
export (float, 1.0, 1.5) var MAX_DIAGONAL_SLOPE = 1.3
var level2_position = Vector3(17.258677, 0, 22.683001)
var reachlevel2 = false

onready var level1 = $"../level1"
onready var level2 = $"../level2"
onready var level3 = $"../level3"
onready var count = 0

export var max_speed = 10
export var friction = 100 # Replace with your desired position
var showDistanceThreshold = 1.0  # Adjust as needed

# Swipe Gesture Detection
var swipe_start_position = Vector2()  # Declare swipe_start_position as a member variable
var swipe_direction = Vector3.ZERO  # Store swipe direction as a member variable

func _ready():
	pass

func _process(delta: float) -> void:
	var direction = get_swipe_direction()
	apply_friction(direction, delta)
	apply_movement(direction, delta)
	var cameraTransform = global_transform
	var newCameraPosition = cameraTransform.origin + swipe_direction * max_speed * delta

	# Check if the new position is within the bounds
	if is_within_bounds(newCameraPosition):

		cameraTransform.origin = newCameraPosition
		global_transform = cameraTransform
		
	#position of every level
	var targetlevel1 = Vector3(-4.42804, 12.2492, 6.40031) 
	var targetlevel2 = Vector3(4 ,12.2492, 6.40031)
	var targetlevel3 = Vector3(19.983038, 12.2492, 6.40031)
	
	var street2 = Vector3(-4.404224, 12.2492, 15.870784)
	var street2_1 = Vector3(19.995716, 12.2492, 14.397369)
	
	var targetlevel4 = Vector3(15, 12.2492, 15)
	
	var cameraPosition = cameraTransform.origin
	var distanceTolevel1 = cameraPosition.distance_to(targetlevel1)
	var distanceTolevel2 = cameraPosition.distance_to(targetlevel2)
	var distanceTolevel3 = cameraPosition.distance_to(targetlevel3)
	var distanceTolevel4 = cameraPosition.distance_to(targetlevel4)
	var distanceTostreet2 = cameraPosition.distance_to(street2)
	var distanceTostreet2_1 = cameraPosition.distance_to(street2_1)
	if distanceTolevel1 < showDistanceThreshold:
		level1.visible = true	
	elif distanceTolevel2 < showDistanceThreshold:
		# Show the label when close to level2_position
		level2.visible = true
		swipe_direction = Vector3.ZERO
	elif distanceTolevel3 < showDistanceThreshold:
		level3.visible = true
	elif distanceTostreet2 < showDistanceThreshold || distanceTostreet2_1 < showDistanceThreshold:
		swipe_direction = Vector3.ZERO
		count += 1
		if count == 1:
			$"../CanvasLayer/AnimationPlayer".play("street2_opening")
			$"../CanvasLayer".visible = true
		
	elif distanceTolevel4 < showDistanceThreshold:
		$"../level4".visible = true
		swipe_direction = Vector3.ZERO
	
	else:
		# Hide the label when not close to either position
		level1.visible = false
		level2.visible = false
		level3.visible = false
		$"../level4".visible = false
		$"../CanvasLayer".visible = false
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


	
