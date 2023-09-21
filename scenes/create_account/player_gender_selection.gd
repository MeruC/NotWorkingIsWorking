extends Spatial

func _on_CheckButton_toggled(button_pressed):
	
	if button_pressed == false:
		var boy = preload("res://resources/Models/Player/Idle/1.obj")
		var boy_skin = preload("res://resources/Models/Player/1.png")
		
		$CSGMesh.mesh = boy
		$CSGMesh.material_override = boy_skin

	elif button_pressed == true:
		var girl = preload("res://resources/Models/Player -girl/idle/idle- Girl.obj")
		var girl_skin = preload("res://resources/Models/Player -girl/idle/idle- Girl.png")
		
		$CSGMesh.mesh = girl
		$CSGMesh.material_override = girl_skin
