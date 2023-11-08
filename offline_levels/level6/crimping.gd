extends Control

var wire_textures = [preload("res://resources/offline_mode_Asset/level_6/blue.png"),#0
						preload("res://resources/offline_mode_Asset/level_6/brown.png"),#1
						preload("res://resources/offline_mode_Asset/level_6/green.png"),#2
						preload("res://resources/offline_mode_Asset/level_6/orange.png"),#3
						preload("res://resources/offline_mode_Asset/level_6/whiteBlue.png"),#4
						preload("res://resources/offline_mode_Asset/level_6/whiteBrown.png"),#5
						preload("res://resources/offline_mode_Asset/level_6/whiteGreen.png"),#6
						preload("res://resources/offline_mode_Asset/level_6/whiteOrange.png")]#7

var cable_types = ["T-568A", "T-568B"]

var arrangement_A = [wire_textures[6], wire_textures[2], wire_textures[7], wire_textures[0], wire_textures[4], wire_textures[3], wire_textures[5], wire_textures[1]]
var arrangement_B = [wire_textures[7], wire_textures[3], wire_textures[6], wire_textures[0], wire_textures[4], wire_textures[2], wire_textures[5], wire_textures[1]]
var arrangement_Ac = [wire_textures[7], wire_textures[3], wire_textures[6], wire_textures[5], wire_textures[1], wire_textures[2], wire_textures[0], wire_textures[4]]
var arrangement_Bc = [wire_textures[6], wire_textures[2], wire_textures[7], wire_textures[5], wire_textures[1], wire_textures[3], wire_textures[0], wire_textures[4]]

export (NodePath) onready var wire_container =  get_node(wire_container) as HBoxContainer
export (NodePath) onready var slot_container =  get_node(slot_container) as Control
export (NodePath) onready var submit_button =  get_node(submit_button) as Button
export (NodePath) onready var type_label =  get_node(type_label) as Label
export (NodePath) onready var game_over =  get_node(game_over) as Control
export (NodePath) onready var gameover_indicator =  get_node(gameover_indicator) as Label
export (NodePath) onready var gameover_score =  get_node(gameover_score) as Label
export (NodePath) onready var crowns = get_node(crowns) as TextureRect
export (NodePath) onready var gameover_anim = get_node(gameover_anim) as AnimationPlayer
export (NodePath) onready var audioplayer = get_node(audioplayer) as AudioStreamPlayer
export (NodePath) onready var celebration = get_node(celebration) as Sprite
export (Resource) var settings_data

onready var price = [{
	"id": "rj45", 
	"quantity": 2
},{
	"id": "blue_cable", 
	"quantity": 1
}]

var end = 1
var type = "n"
var level6 = "res://offline_levels/level6/level6.tscn"
var textures_holder = []
var score
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
	#var number = rand_range(0,2)
	#type_label.text = type_label.text + cable_types[number]
	#cable_types.remove(number)
	##

func _on_start():
	textures_holder = wire_textures.duplicate()
	for child in wire_container.get_children():
		var number = rand_range(0, textures_holder.size())
		child.texture = textures_holder[number]
		child.type = "wire"
		textures_holder.remove(number)
	
	for child in slot_container.get_children():
		child.texture = null
		child.type = "slot"
		
func _next():
	textures_holder = wire_textures.duplicate()
	for child in wire_container.get_children():
		var number = rand_range(0, textures_holder.size())
		child.texture = textures_holder[number]
		child.type = "wire"
		textures_holder.remove(number)
	
	for child in slot_container.get_children():
		child.texture = null
		child.type = "slot"
	

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
	type_label.text = "START CRIMPING"

func _on_crimp_pressed():
	$AudioStreamPlayer2.stream = preload("res://resources/soundtrack/level/crimp.wav")
	$AudioStreamPlayer2.play()
	#yield($AudioStreamPlayer, "finished")
	#$AudioStreamPlayer.stream = preload("res://resources/soundtrack/level/wire.wav")
	# Pagkapress ng crimp pwedeng magkaron ng animated vid na pagccrimp ng cable -
	# bago ilabas yung result
	
	var slot_textures = []
	if slot_container.get_child(0).texture != null && slot_container.get_child(1).texture != null && slot_container.get_child(2).texture != null && slot_container.get_child(3).texture != null && slot_container.get_child(4).texture != null && slot_container.get_child(5).texture != null && slot_container.get_child(6).texture != null && slot_container.get_child(7).texture != null:
		# To store player's wire arrangement
		for child in slot_container.get_children(): 
			slot_textures.append(child.texture)
		##
		
		if end == 2:
			match type:
				"T-568A":
					if slot_textures == arrangement_A:
						type = "Straight-Through"
						type_label.text = type
						end = 1
						_on_craft_complete("straight_through")
					elif slot_textures == arrangement_Ac:
						type = "Cross-Over"
						type_label.text = type
						end = 1
						_on_craft_complete("cross_over")
					else:
						type = "Invalid"
						end = 1
						_on_craft_complete("invalid")
				"T-568B":
					if slot_textures == arrangement_B:
						type = "Straight-Through"
						type_label.text = type
						end = 1
						_on_craft_complete("straight_through")
					elif slot_textures == arrangement_Bc:
						type = "Cross-Over"
						type_label.text = type
						end = 1
						_on_craft_complete("cross_over")
					else:
						type = "Invalid"
						end = 1
						_on_craft_complete("invalid")
				"Invalid":
					type = "Invalid"
					end = 1
					_on_craft_complete("invalid")
		elif end == 1:
			if slot_textures == arrangement_A:
				type = "T-568A"
				type_label.text = type
				end = 2
				_next()

			elif slot_textures == arrangement_B:
				type = "T-568B"
				type_label.text = type
				end = 2
				_next()
			else:
				type = "Invalid"
				type_label.text = type
				end = 2
				_next()
			
		#game_over.visible = true

func score_validation():
	if settings_data.level6 == 5:
		pass
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
			SaveManager.save_game()
		elif score == 0:
			pass


func _on_next_pressed():
	Load.load_scene(self, "res://global/chapters/chapter1.tscn")
	
func _on_craft_complete(type):
	SignalManager.emit_signal("craft_end")
	InventoryManager.remove_items( ItemManager.get_items( price ), "crafting" )
	var produce = [{
		"id": type, 
		"quantity": 1
	}]
	InventoryManager.add_items( ItemManager.get_items( produce ), "player" )
	SaveManager.save_game()
	_on_start()
	get_parent().set_visible(false)


func _on_craft_pressed():
	get_parent().set_visible(false)
	SignalManager.emit_signal("craft_end")
