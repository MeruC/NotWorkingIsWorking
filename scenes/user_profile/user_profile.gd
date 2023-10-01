extends Node2D

var edit_avatar = "res://user_profile/change_avatar.tscn"
var main_menu = "res://scenes/main_screen/main_screen.tscn"
var questionBank_scene = "res://scenes/user_profile/question_bank/question_bank.tscn"
export( Resource ) var settings_data

func _ready():
	Pixelizer.set_visible(false)
	$user_profile/name_background/name.text = settings_data.player_name
	$user_profile/name_background/rank.text = settings_data.rank
	$user_profile/router_progress.min_value = 0  # Set the minimum value
	$user_profile/term_progress.min_value = 0  # Set the minimum value
	$user_profile/router_progress.value = settings_data.net1_skills  # Set the current progress
	$user_profile/term_progress.value = settings_data.net2_skills  # Set the current progress
	var gender = settings_data.gender
	if gender == "female":
		var girl = preload("res://resources/Models/Player -girl/idle/idle- Girl.obj")
		var girl_skin = preload("res://resources/Models/Player -girl/idle/idle- Girl.png")
		$user_profile/ViewportContainer/Viewport/Spatial2/CSGMesh.mesh = girl
		$user_profile/ViewportContainer/Viewport/Spatial2/CSGMesh.material = girl_skin
	if settings_data.email == "":
		$user_profile/logout_bg/logout_btn.text = "Login"
	else:
		$user_profile/logout_bg/logout_btn.text = "Logout"
func _on_edit_avatar_pressed():
	$user_profile.visible = false
	$edit_avatar.visible = true

func _on_back_btn_pressed():
	Load.load_scene(self,main_menu)


func _on_questionBank_btn_pressed():
	Load.load_scene(self, questionBank_scene)


func _on_logout_btn_pressed():
	if settings_data.email == "":
		$login.visible = true
