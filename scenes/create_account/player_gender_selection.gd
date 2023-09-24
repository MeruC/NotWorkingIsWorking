extends Spatial

var click = 0
var gender = ""
export( Resource ) var settings_data

func _ready():
	settings_data.connect("changed", self, "_on_data_changed")
	_on_data_changed()
func _on_CheckButton_toggled(button_pressed):
	if button_pressed == false:
		var boy = preload("res://resources/Models/Player/Idle/1.obj")
		var boy_skin = preload("res://resources/Models/Player/1.png")
		
		$"../../../../choose_male".visible = true
		$"../../../../choose_female".visible = false
		$CSGMesh.mesh = boy
		$CSGMesh.material_override = boy_skin
		$"../../../../AnimationPlayer".play("male_anim")
		gender = "male"

	elif button_pressed == true:
		$"../../../../choose_female".visible = true
		$"../../../../choose_male".visible = false
		$"../../../../AnimationPlayer".play("female_anim")
		var girl = preload("res://resources/Models/Player -girl/idle/idle- Girl.obj")
		var girl_skin = preload("res://resources/Models/Player -girl/idle/idle- Girl.png")
		
		$CSGMesh.mesh = girl
		$CSGMesh.material_override = girl_skin
		gender = "female"
	settings_data.gender = gender
	SaveManager.save_game()
	
func _on_confirm_pressed():
	$"../../../..".queue_free()
	Load.load_scene(self,"res://scenes/main_screen/main_screen.tscn")

func _on_data_changed():
	settings_data.gender = gender
