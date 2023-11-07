extends Control

var wire_textures = [preload("res://resources/offline_mode_Asset/level_6/blue.png"),
						preload("res://resources/offline_mode_Asset/level_6/brown.png"),
						preload("res://resources/offline_mode_Asset/level_6/green.png"),
						preload("res://resources/offline_mode_Asset/level_6/orange.png"),
						preload("res://resources/offline_mode_Asset/level_6/whiteBlue.png"),
						preload("res://resources/offline_mode_Asset/level_6/whiteBrown.png"),
						preload("res://resources/offline_mode_Asset/level_6/whiteGreen.png"),
						preload("res://resources/offline_mode_Asset/level_6/whiteOrange.png")]

var cable_types = ["T-568A", "T-568B"]

var arrangement_A = [wire_textures[6], wire_textures[2], wire_textures[7], wire_textures[0], wire_textures[4], wire_textures[3], wire_textures[5], wire_textures[1]]
var arrangement_B = [wire_textures[7], wire_textures[3], wire_textures[6], wire_textures[0], wire_textures[4], wire_textures[2], wire_textures[5], wire_textures[1]]

export (NodePath) onready var wire_container =  get_node(wire_container) as HBoxContainer
export (NodePath) onready var slot_container =  get_node(slot_container) as Control
export (NodePath) onready var submit_button =  get_node(submit_button) as Button
export (NodePath) onready var type_label =  get_node(type_label) as Label
export (NodePath) onready var game_over =  get_node(game_over) as Control
export (NodePath) onready var gameover_indicator =  get_node(gameover_indicator) as Label
export (NodePath) onready var gameover_score =  get_node(gameover_score) as Label
export (NodePath) onready var popup_next_button = get_node(popup_next_button) as Button
export (NodePath) onready var popup_retry_button = get_node(popup_retry_button) as Button
export (NodePath) onready var crowns = get_node(crowns) as TextureRect
export (NodePath) onready var gameover_anim = get_node(gameover_anim) as AnimationPlayer
export (NodePath) onready var audioplayer = get_node(audioplayer) as AudioStreamPlayer
export (NodePath) onready var celebration = get_node(celebration) as Sprite
export (NodePath) onready var tutorial_player = get_node(tutorial_player) as AnimationPlayer
export (NodePath) onready var instruction_sprite = get_node(instruction_sprite) as Sprite
export (Resource) var settings_data

var level6 = "res://offline_levels/level6/level6.tscn"
var textures_holder = []
var score
func _ready():
	# To set the texture of wires in a random order
	tutorial_player.play("level6_tutorial")
	textures_holder = wire_textures.duplicate()
	for child in wire_container.get_children():
		var number = rand_range(0, textures_holder.size())
		child.texture = textures_holder[number]
		child.type = "wire"
		textures_holder.remove(number)
	##
	
	# To display which type of cable to be configured
	var number = rand_range(0,2)
	type_label.text = type_label.text + cable_types[number]
	cable_types.remove(number)
	##


func _on_reset_pressed():
	$AudioStreamPlayer2.stream = preload("res://resources/soundtrack/level/undo_click.wav")
	$AudioStreamPlayer2.play()
	textures_holder = wire_textures.duplicate()
	for child in wire_container.get_children():
		var number = rand_range(0, textures_holder.size())
		child.texture = textures_holder[number]
		child.type = "wire"
		textures_holder.remove(number)
	
	for child in slot_container.get_children():
		child.texture = null
		child.type = "slot"


func _on_crimp_pressed():
	$AudioStreamPlayer2.stream = preload("res://resources/soundtrack/level/crimp.wav")
	$AudioStreamPlayer2.play()
	# Pagkapress ng crimp pwedeng magkaron ng animated vid na pagccrimp ng cable -
	# bago ilabas yung result
	
	var slot_textures = []
	if slot_container.get_child(0).texture != null && slot_container.get_child(1).texture != null && slot_container.get_child(2).texture != null && slot_container.get_child(3).texture != null && slot_container.get_child(4).texture != null && slot_container.get_child(5).texture != null && slot_container.get_child(6).texture != null && slot_container.get_child(7).texture != null:
		# To store player's wire arrangement
		for child in slot_container.get_children(): 
			slot_textures.append(child.texture)
		##
			
		if type_label.text.to_upper() == "WIRING STANDARD: T-568A":
			if slot_textures == arrangement_A:
				gameover_anim.play("win")
				celebration.visible = true
				audioplayer.play()
				gameover_indicator.text = "Level Complete!"
				gameover_score.text = "Your Score: 5 / 5"
				score = 5
				crowns.texture = preload("res://resources/Game buttons/3_crowns.png")
				score_validation()
			else:
				audioplayer.stream = preload("res://resources/soundtrack/game_over/losegamemusic.wav")
				audioplayer.play()
				gameover_anim.play("lose")
				gameover_indicator.text = "Level Failed"
				gameover_score.text = "Your Score: 0 / 5"
				crowns.texture = preload("res://resources/Game buttons/0_crowns.png")
				score = 0
		elif type_label.text.to_upper() == "WIRING STANDARD: T-568B":
			if slot_textures == arrangement_B:
				gameover_anim.play("win")
				celebration.visible = true
				audioplayer.play()
				gameover_indicator.text = "Level Complete!"
				gameover_score.text = "Your Score: 5 / 5"
				score = 5
				crowns.texture = preload("res://resources/Game buttons/3_crowns.png")
				score_validation()
			else:
				audioplayer.stream = preload("res://resources/soundtrack/game_over/losegamemusic.wav")
				audioplayer.play()
				gameover_anim.play("lose")
				gameover_indicator.text = "Level Failed"
				gameover_score.text = "Your Score: 0 / 5"
				crowns.texture = preload("res://resources/Game buttons/0_crowns.png")
				score = 0
		game_over.visible = true

func score_validation():
	if settings_data.level6 > 0:
		return
	if settings_data.quick_game == "isplaying":
		popup_next_button.disabled = true
		popup_retry_button.disabled = true
		
		if settings_data.reset_timer >= 10800:
			if score == 5:
				settings_data.reset_timer = 0
				var current_coins = settings_data.gold_coins
				var new_coins = current_coins+100
				settings_data.gold_coins = new_coins
				settings_data.quick_game = "notplaying"
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
			settings_data.level6 = 5
			settings_data.reset_timer = 10800.18888
			SaveManager.save_game()
		elif score == 0:
			return


func _on_next_pressed():
	Load.load_scene(self, "res://global/chapters/chapter1.tscn")


func _on_Button_pressed():
	$popup_layer/instructions.visible = true
	instruction_sprite.visible = true
