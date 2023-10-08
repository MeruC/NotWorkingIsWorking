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
export (Resource) var settings_data

var level6 = "res://offline_levels/level6/level6.tscn"
var textures_holder = []

func _ready():
	# To set the texture of wires in a random order
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
				gameover_indicator.text = "Level Complete!"
				gameover_score.text = "Your Score: 5 / 5"
				score_validation()
			else:
				gameover_indicator.text = "Level Failed"
				gameover_score.text = "Your Score: 0 / 5"
		elif type_label.text.to_upper() == "WIRING STANDARD: T-568B":
			if slot_textures == arrangement_B:
				gameover_indicator.text = "Level Complete!"
				gameover_score.text = "Your Score: 5 / 5"
				score_validation()
			else:
				gameover_indicator.text = "Level Failed"
				gameover_score.text = "Your Score: 0 / 5"
		game_over.visible = true

func score_validation():
	if settings_data.level6 == "complete":
		pass
	else:
		var current_coins = settings_data.gold_coins
		var new_coins = current_coins+100
		
		var skills = settings_data.net1_skills
		var update_skills = skills+10
		
		settings_data.gold_coins = new_coins
		settings_data.net1_skills = update_skills
		settings_data.level6 = "complete"
		SaveManager.save_game()
