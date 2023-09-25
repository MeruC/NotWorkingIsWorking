extends Spatial

export var rotate_speed : float

func _process(delta):
	self.rotate_y(rotate_speed * delta)
