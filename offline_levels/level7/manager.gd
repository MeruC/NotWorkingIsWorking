extends Control

export(NodePath) onready var topology_image = get_node(topology_image) as TextureRect
export(NodePath) onready var number_label = get_node(number_label) as Label
export(NodePath) onready var star_button = get_node(star_button) as Button
export(NodePath) onready var bus_button = get_node(bus_button) as Button
export(NodePath) onready var ring_button = get_node(ring_button) as Button
export(NodePath) onready var mesh_button = get_node(mesh_button) as Button
export(NodePath) onready var hybrid_button = get_node(hybrid_button) as Button
export(NodePath) onready var gameover_popup = get_node(gameover_popup) as Control
export(NodePath) onready var gameover_indicator = get_node(gameover_indicator) as Label
export(NodePath) onready var gameover_score = get_node(gameover_score) as Label
export(NodePath) onready var gameover_next = get_node(gameover_next) as Button
export(NodePath) onready var gameover_retry = get_node(gameover_retry) as Button
export(NodePath) onready var crowns = get_node(crowns) as TextureRect
export(NodePath) onready var gameover_anim = get_node(gameover_anim) as AnimationPlayer
export(NodePath) onready var celebration = get_node(celebration) as Sprite
export(NodePath) onready var audioplayer = get_node(audioplayer) as AudioStreamPlayer
export(NodePath) onready var tutorial_player = get_node(tutorial_player) as AnimationPlayer
export(NodePath) onready var instruction_sprite = get_node(instruction_sprite) as Sprite
export(NodePath) onready var net1_skills = get_node(net1_skills) as Label
export(NodePath) onready var coins = get_node(coins) as Label
## result
export(NodePath) onready var result_anim = get_node(result_anim) as AnimationPlayer
export(NodePath) onready var mascot = get_node(mascot) as Sprite
export(NodePath) onready var bg = get_node(bg) as ColorRect

export(Resource) var settings_data

var topologies = [preload("res://resources/offline_mode_Asset/level_7/bus_topology.png"),
					preload("res://resources/offline_mode_Asset/level_7/hybrid_topology.png"),
					preload("res://resources/offline_mode_Asset/level_7/mesh_topology.png"),
					preload("res://resources/offline_mode_Asset/level_7/ring_topology.png"),
					preload("res://resources/offline_mode_Asset/level_7/star_topology.png")]
					
var contents = ["BUS TOPOLOGY", "HYBRID TOPOLOGY", "MESH TOPOLOGY", "RING TOPOLOGY", "STAR TOPOLOGY"]
					
var current_number = 1
var score = 0

func _ready():
	tutorial_player.play("level7_tutorial")
	display_image()

func display_image():
	number_label.text = str(score)
	var i = rand_range(0,topologies.size())
	topology_image.texture = topologies[i]
	topologies.remove(i)
	topology_image.content = contents[i]
	contents.remove(i)
	current_number += 1

func check_answer(answer):
	if answer == topology_image.content:
		score += 1
		result_anim.play("win")
		mascot.texture = preload("res://resources/Game buttons/cat_win.png")
		mascot.visible = true
		bg.visible = true
		yield(get_tree().create_timer(1.0), "timeout")
		mascot.visible = false
		bg.visible = false
	else:
		mascot.texture = preload("res://resources/Game buttons/cat_incorrect.png")
		mascot.visible = true
		bg.visible = true
		result_anim.play("win")
		yield(get_tree().create_timer(1.0), "timeout")
		mascot.visible = false
		bg.visible = false
	if current_number != 6:
		display_image()
	else:
		display_gameover()

func display_gameover():
	var score_text = ""
	$counter.visible = false
	if score > 2:
		gameover_anim.play("win")
		celebration.visible = true
		audioplayer.play()
		gameover_indicator.text = "Level Complete!"
		score_text = "Score: " + str(score)
		gameover_score.text = score_text
		gameover_next.disabled = false
		if score == 5:
			crowns.texture = preload("res://resources/Game buttons/3_crowns.png")
			net1_skills.text = "Networking 1 skills: 10"
			coins.text = "+100"
		elif score == 4:
			crowns.texture = preload("res://resources/Game buttons/2_crowns.png")
			net1_skills.text = "Networking 1 skills: 10"
			coins.text = "+90"
		elif score == 3:
			crowns.texture = preload("res://resources/Game buttons/1_crowns.png")
			net1_skills.text = "Networking 1 skills: 10"
			coins.text = "+80"
		score_validation()
		
	else:
		audioplayer.stream = preload("res://resources/soundtrack/game_over/losegamemusic.wav")
		audioplayer.play()
		gameover_anim.play("lose")
		gameover_indicator.text = "Level Failed"
		score_text = "Score: " + str(score)
		gameover_score.text = score_text
		gameover_next.disabled = true
		if score < 3:
			crowns.texture = preload("res://resources/Game buttons/0_crowns.png")
			net1_skills.text = "Networking 1 skills: 0"
			coins.text = "+0"
	gameover_popup.visible = true


func _on_star_pressed():
	$AudioStreamPlayer.play()
	check_answer(star_button.text.to_upper())


func _on_bus_pressed():
	$AudioStreamPlayer.play()
	check_answer(bus_button.text.to_upper())


func _on_ring_pressed():
	$AudioStreamPlayer.play()
	check_answer(ring_button.text.to_upper())


func _on_mesh_pressed():
	$AudioStreamPlayer.play()
	check_answer(mesh_button.text.to_upper())


func _on_hybrid_pressed():
	$AudioStreamPlayer.play()
	check_answer(hybrid_button.text.to_upper())


func _on_retry_pressed():
	$AudioStreamPlayer.play()
	get_tree().reload_current_scene()

func score_validation():
	if settings_data.level7 > 0:
		net1_skills.text = "Networking 1 skills: 0"
		coins.text = "+0"
		return
		
	if settings_data.quick_game == "isplaying":
		gameover_next.disabled = true
		gameover_retry.disabled = true
		net1_skills.text = "Networking 1 skills: 0"
		if settings_data.reset_timer >= 10800:
			if score == 5:
				var current_coins = settings_data.gold_coins
				var new_coins = current_coins+100
				settings_data.gold_coins = new_coins
				settings_data.reset_timer = 0
				settings_data.quick_game = "notplaying"
				SaveManager.save_game()
			elif score >= 3 and score <= 4:
				var current_coins = settings_data.gold_coins
				var new_coins = current_coins+90
				settings_data.gold_coins = new_coins
				settings_data.reset_timer = 0
				settings_data.quick_game = "notplaying"
				SaveManager.save_game()
			elif score <= 2 and score > 0:
				var current_coins = settings_data.gold_coins
				var new_coins = current_coins+80
				settings_data.gold_coins = new_coins
				settings_data.reset_timer = 0
				settings_data.quick_game = "notplaying"
				SaveManager.save_game()
			elif score == 0:
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
			settings_data.level7 = score
			settings_data.reset_timer = 10800.18888
			SaveManager.save_game()
		elif score >= 3 and score <= 4:
			settings_data.crowns += 2
			var current_coins = settings_data.gold_coins
			var new_coins = current_coins+90
			var skills = settings_data.net1_skills
			var update_skills = skills+10
			settings_data.gold_coins = new_coins
			settings_data.net1_skills = update_skills
			settings_data.level7 = score
			settings_data.reset_timer = 10800.18888
			SaveManager.save_game()
		elif score <= 2 and score > 0:
			settings_data.crowns += 1
			var current_coins = settings_data.gold_coins
			var new_coins = current_coins+80
			var skills = settings_data.net1_skills
			var update_skills = skills+10
			settings_data.gold_coins = new_coins
			settings_data.net1_skills = update_skills
			settings_data.level7 = score
			settings_data.reset_timer = 10800.18888
			SaveManager.save_game()
		elif score == 0:
			return


func _on_next_pressed():
	Load.load_scene(self,"res://global/chapters/chapter1.tscn")


func _on_instruction_pressed():
	$popup_layer/instructions.visible = true
	instruction_sprite.visible = true
