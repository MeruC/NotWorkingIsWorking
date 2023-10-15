extends CSGMesh

export (Resource) var settings_data
var rotation_speed = 0.1

func _ready():
	var costume = settings_data.costume
	var gender = settings_data.gender
	if settings_data.gender == "female":
		if costume == "female":
			var girl = preload("res://resources/Models/Player -girl/idle/idle- Girl.obj")
			var girl_skin = preload("res://resources/Models/Player -girl/idle/idle- Girl.png")
			$".".mesh = girl
			$".".material_override = girl_skin
		if costume == "girl_pants":
			var girl_pants = preload("res://resources/Models/Character skin girl/default_pants/idle/idle.obj")
			var girl_pants_skin = preload("res://resources/Models/Character skin girl/default_pants/idle/idle.png")
			$".".mesh = girl_pants
			$".".material_override = girl_pants_skin
		if costume == "girl_casual":
			var girl_casual = preload("res://resources/Models/Character skin girl/casual_attire/idle/idle.obj")
			var girl_casual_skin = preload("res://resources/Models/Character skin girl/casual_attire/idle/idle.png")
			$".".mesh = girl_casual
			$".".material_override = girl_casual_skin
	if settings_data.gender == "male":
		if costume == "male":
			var boy = preload("res://resources/Models/Player/Idle/1.obj")
			var boy_skin = preload("res://resources/Models/Player/1.png")
			$".".mesh = boy
			$".".material_override = boy_skin
		if costume == "blue_shirt":
			var boy_blue_shirt = preload("res://resources/Models/Character skin boy/blue_shirt/idle/idle.obj")
			var boy_blue_shirt_skin = preload("res://resources/Models/Character skin boy/blue_shirt/idle/idle.png")
			$".".mesh = boy_blue_shirt
			$".".material_override = boy_blue_shirt_skin
		if costume == "cict_shirt":
			var boy_cict_shirt = preload("res://resources/Models/Character skin boy/cict_shirt/idle/idle.obj")
			var boy_cict_shirt_skin = preload("res://resources/Models/Character skin boy/cict_shirt/idle/idle.png")
			$".".mesh = boy_cict_shirt
			$".".material_override = boy_cict_shirt_skin
		if costume == "formal_attire":
			var boy_formal_attire = preload("res://resources/Models/Character skin boy/formal_attire/idle/idle.obj")
			var boy_formal_attire_skin = preload("res://resources/Models/Character skin boy/formal_attire/idle/idle.png")
			$".".mesh = boy_formal_attire
			$".".material_override = boy_formal_attire_skin
		if costume == "orange_shirt":
			var boy_orange_shirt = preload("res://resources/Models/Character skin boy/orange_shirt/idle/idle.obj")
			var boy_orange_shirt_skin = preload("res://resources/Models/Character skin boy/orange_shirt/idle/idle.png")
			$".".mesh = boy_orange_shirt
			$".".material_override = boy_orange_shirt_skin
func _process(delta):
	$".".rotate_y(rotation_speed * delta)
	
func _change_costume():
	var costume = settings_data.costume
	var gender = settings_data.gender
	if settings_data.gender == "female":
		if costume == "female":
			var girl = preload("res://resources/Models/Player -girl/idle/idle- Girl.obj")
			var girl_skin = preload("res://resources/Models/Player -girl/idle/idle- Girl.png")
			$".".mesh = girl
			$".".material_override = girl_skin
		if costume == "girl_pants":
			var girl_pants = preload("res://resources/Models/Character skin girl/default_pants/idle/idle.obj")
			var girl_pants_skin = preload("res://resources/Models/Character skin girl/default_pants/idle/idle.png")
			$".".mesh = girl_pants
			$".".material_override = girl_pants_skin
		if costume == "girl_casual":
			var girl_casual = preload("res://resources/Models/Character skin girl/casual_attire/idle/idle.obj")
			var girl_casual_skin = preload("res://resources/Models/Character skin girl/casual_attire/idle/idle.png")
			$".".mesh = girl_casual
			$".".material_override = girl_casual_skin
	if settings_data.gender == "male":
		if costume == "male":
			var boy = preload("res://resources/Models/Player/Idle/1.obj")
			var boy_skin = preload("res://resources/Models/Player/1.png")
			$".".mesh = boy
			$".".material_override = boy_skin
		if costume == "blue_shirt":
			var boy_blue_shirt = preload("res://resources/Models/Character skin boy/blue_shirt/idle/idle.obj")
			var boy_blue_shirt_skin = preload("res://resources/Models/Character skin boy/blue_shirt/idle/idle.png")
			$".".mesh = boy_blue_shirt
			$".".material_override = boy_blue_shirt_skin
		if costume == "cict_shirt":
			var boy_cict_shirt = preload("res://resources/Models/Character skin boy/cict_shirt/idle/idle.obj")
			var boy_cict_shirt_skin = preload("res://resources/Models/Character skin boy/cict_shirt/idle/idle.png")
			$".".mesh = boy_cict_shirt
			$".".material_override = boy_cict_shirt_skin
		if costume == "formal_attire":
			var boy_formal_attire = preload("res://resources/Models/Character skin boy/formal_attire/idle/idle.obj")
			var boy_formal_attire_skin = preload("res://resources/Models/Character skin boy/formal_attire/idle/idle.png")
			$".".mesh = boy_formal_attire
			$".".material_override = boy_formal_attire_skin
		if costume == "orange_shirt":
			var boy_orange_shirt = preload("res://resources/Models/Character skin boy/orange_shirt/idle/idle.obj")
			var boy_orange_shirt_skin = preload("res://resources/Models/Character skin boy/orange_shirt/idle/idle.png")
			$".".mesh = boy_orange_shirt
			$".".material_override = boy_orange_shirt_skin
		
