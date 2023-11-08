extends Control

export (PackedScene) var choice_scene
export (Resource) var settings_data


var score = 0
var json_file = "res://offline_levels/json/level3_questions.json"
var json_data = ""
var i
var answer


export(NodePath) onready var clue_label = get_node(clue_label) as Label
export(NodePath) onready var score_label = get_node(score_label) as Label
export(NodePath) onready var choice1 = get_node(choice1) as TextureRect
export(NodePath) onready var choice2 = get_node(choice2) as TextureRect
export(NodePath) onready var choices = get_node(choices) as Node2D

# Gameover popup paths
export(NodePath) onready var popup_score_label = get_node(popup_score_label) as Label
export(NodePath) onready var game_over_popup = get_node(game_over_popup) as Control
export(NodePath) onready var popup_next_button = get_node(popup_next_button) as Button
export(NodePath) onready var popup_retry_button = get_node(popup_retry_button) as Button
export(NodePath) onready var popup_indicator_label = get_node(popup_indicator_label) as Label
export(NodePath) onready var crowns = get_node(crowns) as TextureRect
export(NodePath) onready var celebration = get_node(celebration) as Sprite
export(NodePath) onready var gameover_anim =  get_node(gameover_anim) as AnimationPlayer
export(NodePath) onready var audioplayer = get_node(audioplayer) as AudioStreamPlayer
export(NodePath) onready var net1_skills = get_node(net1_skills) as Label
export(NodePath) onready var coins = get_node(coins) as Label
##

# result path
export(NodePath) onready var mascot = get_node(mascot) as Sprite
export(NodePath) onready var bg = get_node(bg) as ColorRect
export(NodePath) onready var animationplayer =  get_node(animationplayer) as AnimationPlayer
##

# Instructions popup paths
export(NodePath) onready var animation_player = get_node(animation_player) as AnimationPlayer
export(NodePath) onready var instructions_popup = get_node(instructions_popup) as Control
export(NodePath) onready var instructions_sprite = get_node(instructions_sprite) as Sprite
##

var home_scene = "res://scenes/main_screen/main_screen.tscn"
var level3_scene = "res://offline_levels/level3/level3.tscn"
	

# Called when the node enters the scene tree for the first time.
func _ready():
	animation_player.play("level3_tutorial")
	var file = File.new()
	if file.open(json_file, File.READ) == OK:
		var json_content = file.get_as_text()
		file.close()
		var json_result = JSON.parse(json_content)
		if json_result.error == OK:
			json_data = json_result.result
		else:
			print("JSON parsing error:", json_result.error_string)
	else:
		print("Failed to open JSON file.")
		
	i = 0
	var clue = json_data[i]["question"]
	var incorrect = json_data[i]["incorrect"]
	answer = json_data[i]["answer"]
	clue_label.text = clue
	
	var random = randi() % 2
	if random == 0:
		choice1.content = answer
		choice1.texture = load("res://resources/offline_mode_Asset/level_3/" + answer + ".png")
		choice2.content = incorrect
		choice2.texture = load("res://resources/offline_mode_Asset/level_3/" + incorrect + ".png")
	else:
		choice2.content = answer
		choice2.texture = load("res://resources/offline_mode_Asset/level_3/" + answer + ".png")
		choice1.content = incorrect
		choice1.texture = load("res://resources/offline_mode_Asset/level_3/" + incorrect + ".png")
	return json_data
		
	pass # Replace with function body.

func _on_choice1_pressed():
	$AudioStreamPlayer.play()
	i += 1
	var choice = choice1.content
	if choice == answer:
		score += 1
		score_label.text = str(score)
		mascot.texture = preload("res://resources/Game buttons/cat_win.png")
		mascot.visible = true
		bg.visible = true
		animationplayer.play("win")
		yield(get_tree().create_timer(1.0), "timeout")
		mascot.visible = false
		bg.visible = false
	else:
		mascot.texture = preload("res://resources/Game buttons/cat_incorrect.png")
		mascot.visible = true
		bg.visible = true
		animationplayer.play("win")
		yield(get_tree().create_timer(1.0), "timeout")
		mascot.visible = false
		bg.visible = false
		
	while i < 5:
		var clue = json_data[i]["question"]
		var incorrect = json_data[i]["incorrect"]
		answer = json_data[i]["answer"]
		clue_label.text = clue
			
		var random = randi() % 2
		if random == 0:
			choice1.content = answer
			choice1.texture = load("res://resources/offline_mode_Asset/level_3/" + answer + ".png")
			choice2.content = incorrect
			choice2.texture = load("res://resources/offline_mode_Asset/level_3/" + incorrect + ".png")
		else:
			choice2.content = answer
			choice2.texture = load("res://resources/offline_mode_Asset/level_3/" + answer + ".png")
			choice1.content = incorrect
			choice1.texture = load("res://resources/offline_mode_Asset/level_3/" + incorrect + ".png")
		return json_data
	#	new_questions()
	
	popup_score_label.text = "Score: " + score_label.text
	if int(score_label.text) > 2:
		popup_next_button.disabled = false
		popup_indicator_label.text = "Level Complete!"
		gameover_anim.play("win")
		if score == 4:
			game_over_popup.visible = true
			gameover_anim.play("win")
			audioplayer.stream = preload("res://resources/soundtrack/game_over/Won!.wav")
			audioplayer.play()
			celebration.visible = true
			crowns.texture = preload("res://resources/Game buttons/2_crowns.png")
			net1_skills.text = "Networking 1 skills: 10"
			coins.text = "+90"
		if score == 5:
			game_over_popup.visible = true
			gameover_anim.play("win")
			audioplayer.stream = preload("res://resources/soundtrack/game_over/Won!.wav")
			audioplayer.play()
			celebration.visible = true
			crowns.texture = preload("res://resources/Game buttons/3_crowns.png")
			net1_skills.text = "Networking 1 skills: 10"
			coins.text = "+100"	
		if score == 3:
			game_over_popup.visible = true
			audioplayer.stream = preload("res://resources/soundtrack/game_over/Won!.wav")
			audioplayer.play()
			crowns.texture = preload("res://resources/Game buttons/1_crowns.png")
			net1_skills.text = "Networking 1 skills: 10"
			coins.text = "+90"
		score_validation()
	else:
		popup_next_button.disabled = true
		popup_indicator_label.text = "Level Failed!"
		if score < 3:
			net1_skills.text = "Networking 1 skills: 0"
			coins.text = "+0"
			game_over_popup.visible = true
			audioplayer.stream = preload("res://resources/soundtrack/game_over/losegamemusic.wav")
			audioplayer.play()
			gameover_anim.play("lose")
			crowns.texture = preload("res://resources/Game buttons/0_crowns.png")
	clue_label.queue_free()
	choices.queue_free()
	#show_gameover()

func _on_choice2_pressed():
	i += 1
	$AudioStreamPlayer.play()
	var choice = choice2.content
	if choice == answer:
		score += 1
		score_label.text = str(score)
		mascot.texture = preload("res://resources/Game buttons/cat_win.png")
		mascot.visible = true
		bg.visible = true
		animationplayer.play("win")
		yield(get_tree().create_timer(1.0), "timeout")
		mascot.visible = false
		bg.visible = false
		
	else:
		mascot.texture = preload("res://resources/Game buttons/cat_incorrect.png")
		mascot.visible = true
		bg.visible = true
		animationplayer.play("win")
		yield(get_tree().create_timer(1.0), "timeout")
		mascot.visible = false
		bg.visible = false
	
	while i < 5:
		var clue = json_data[i]["question"]
		var incorrect = json_data[i]["incorrect"]
		answer = json_data[i]["answer"]
		clue_label.text = clue
			
		var random = randi() % 2
		if random == 0:
			choice1.content = answer
			choice1.texture = load("res://resources/offline_mode_Asset/level_3/" + answer + ".png")
			choice2.content = incorrect
			choice2.texture = load("res://resources/offline_mode_Asset/level_3/" + incorrect + ".png")
		else:
			choice2.content = answer
			choice2.texture = load("res://resources/offline_mode_Asset/level_3/" + answer + ".png")
			choice1.content = incorrect
			choice1.texture = load("res://resources/offline_mode_Asset/level_3/" + incorrect + ".png")
		return json_data
	#	new_questions()
	
	popup_score_label.text = "Score: " + score_label.text
	if int(score_label.text) > 2 :
		audioplayer.stream = preload("res://resources/soundtrack/game_over/Won!.wav")
		audioplayer.play()
		game_over_popup.visible = true
		gameover_anim.play("win")
		popup_next_button.disabled = false
		popup_indicator_label.text = "Level Complete!"
		if score == 5:
			game_over_popup.visible = true
			animationplayer.play("win")
			crowns.texture = preload("res://resources/Game buttons/3_crowns.png")
			net1_skills.text = "Networking 1 skills: 10"
			coins.text = "+100"
		elif score == 4:
			game_over_popup.visible = true
			animationplayer.play("win")
			crowns.texture = preload("res://resources/Game buttons/2_crowns.png")
			net1_skills.text = "Networking 1 skills: 10"
			coins.text = "+90"
		if score == 3:
			game_over_popup.visible = true
			animationplayer.play("win")
			crowns.texture = preload("res://resources/Game buttons/1_crowns.png")
			net1_skills.text = "Networking 1 skills: 10"
			coins.text = "+90"
		score_validation()
	else:
		audioplayer.stream = preload("res://resources/soundtrack/game_over/losegamemusic.wav")
		audioplayer.play()
		gameover_anim.play("lose")
		game_over_popup.visible = true
		animationplayer.play("lose")
		popup_next_button.disabled = true
		popup_indicator_label.text = "Level Failed!"
		
		if score < 3:
			game_over_popup.visible = true
			animationplayer.play("lose")
			crowns.texture = preload("res://resources/Game buttons/0_crowns.png")
			net1_skills.text = "Networking 1 skills: 0"
			coins.text = "+0"
	game_over_popup.visible = true
	
	clue_label.queue_free()
	choices.queue_free()
	

func _on_tap_pressed():
	instructions_popup.visible = false
	instructions_sprite.visible = false


func score_validation():
	if settings_data.level3 > 0:
		net1_skills.text = "Networking 1 knowledge: 0"
		coins.text = "+0"
		return
	if settings_data.quick_game == "isplaying":
		net1_skills.text = "Networking 1 knowledge: 0"
		popup_next_button.disabled = true
		popup_retry_button.disabled = true
		
		if settings_data.reset_timer >= 10800:
			if score == 5:
				var current_coins = settings_data.gold_coins
				var new_coins = current_coins+100
				settings_data.gold_coins = new_coins
				settings_data.quick_game = "notplaying"
				settings_data.reset_timer = 0
				SaveManager.save_game()
			elif score > 3 or score == 4:
				var current_coins = settings_data.gold_coins
				var new_coins = current_coins+90
				settings_data.gold_coins = new_coins
				settings_data.quick_game = "notplaying"
				settings_data.reset_timer = 0
				SaveManager.save_game()
			else:
				settings_data.reset_timer = 0
				settings_data.quick_game = "notplaying"
				SaveManager.save_game()
		else:
			settings_data.quick_game = "notplaying"
			SaveManager.save_game()
			
	else:
		if score == 5:
			settings_data.crowns += 3
			var current_coins = settings_data.gold_coins
			var new_coins = current_coins+100
			var skills = settings_data.net1_skills
			var update_skills = skills+10
			settings_data.gold_coins = new_coins
			settings_data.net1_skills = update_skills
			settings_data.level3 = score
			settings_data.reset_timer = 10800.18888
			SaveManager.save_game()
			
		elif score >= 3 or score == 4:
			settings_data.crowns += 2
			var current_coins = settings_data.gold_coins
			var new_coins = current_coins+90
			var skills = settings_data.net1_skills
			var update_skills = skills+10
			settings_data.gold_coins = new_coins
			settings_data.net1_skills = update_skills
			settings_data.level3 = score
			settings_data.reset_timer = 10800.18888
			SaveManager.save_game()
		elif score <= 2 or score > 0:
			settings_data.level3 = score
			SaveManager.save_game()
		elif score == 0:
			return
			

# Display new set of question and options
#func new_questions():
#	var clue = json_data[i]["question"]
#	var incorrect = json_data[i]["incorrect"]
#	answer = json_data[i]["answer"]
#	clue_label.text = clue
#		
#	var random = randi() % 2
#	if random == 0:
#		choice1.content = answer
#		choice1.texture = load("res://offline_mode_Asset/level_3/" + answer + ".png")
#		choice2.content = incorrect
#		choice2.texture = load("res://offline_mode_Asset/level_3/" + incorrect + ".png")
#	else:
#		choice2.content = answer
#		choice2.texture = load("res://offline_mode_Asset/level_3/" + answer + ".png")
#		choice1.content = incorrect
#		choice1.texture = load("res://offline_mode_Asset/level_3/" + incorrect + ".png")
#	return json_data
##

# To display the gameover popup
#func show_gameover():
#	popup_score_label.text = "Your Score: " + score_label.text + " / 5"
#	if int(score_label.text) >= 4:
#		popup_next_button.disabled = false
#		popup_indicator_label.text = "Level Complete!"
#	else:
#		popup_next_button.disabled = true
#		popup_indicator_label.text = "Level Failed!"
#	game_over_popup.visible = true
#	
#	clue_label.queue_free()
#	choices.queue_free()
##


func _on_restart_pressed():
	Load.load_scene(self,level3_scene)

func _on_home_pressed():
	$".".queue_free()
	Load.load_scene(self,home_scene)

func _on_next_pressed():
	$".".queue_free()
	Load.load_scene(self,"res://global/chapters/chapter1.tscn")

func _on_retry_pressed():
	Load.load_scene(self,level3_scene)


func _on_Button_pressed():
	$popup_layer/instructions.visible = true
	instructions_sprite.visible = true
