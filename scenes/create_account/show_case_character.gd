extends CSGMesh

var rotation_speed = 1.0

func _process(delta):
	$".".rotate_y(rotation_speed * delta)
