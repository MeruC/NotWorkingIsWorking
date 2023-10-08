extends CSGMesh

export (Resource) var settings_data
var rotation_speed = 0.1

func _ready():
	var gender = settings_data.gender
	
	if gender == "female":
		var girl = preload("res://resources/Models/Player -girl/idle/idle- Girl.obj")
		var girl_skin = preload("res://resources/Models/Player -girl/idle/idle- Girl.png")
		$".".mesh = girl
		$".".material_override = girl_skin
		
func _process(delta):
	$".".rotate_y(rotation_speed * delta)
