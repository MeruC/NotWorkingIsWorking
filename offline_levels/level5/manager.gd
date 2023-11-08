extends Control

var level5_scene = "res://offline_levels/level5/level5.tscn"

export(NodePath) onready var layer1 = get_node(layer1) as TextureRect
export(NodePath) onready var layer2 = get_node(layer2) as TextureRect
export(NodePath) onready var layer3 = get_node(layer3) as TextureRect
export(NodePath) onready var layer4 = get_node(layer4) as TextureRect
export(NodePath) onready var layer5 = get_node(layer5) as TextureRect
export(NodePath) onready var layer6 = get_node(layer6) as TextureRect
export(NodePath) onready var layer7 = get_node(layer7) as TextureRect
export(NodePath) onready var slot1 = get_node(slot1) as TextureRect
export(NodePath) onready var slot2 = get_node(slot2) as TextureRect
export(NodePath) onready var slot3 = get_node(slot3) as TextureRect
export(NodePath) onready var slot4 = get_node(slot4) as TextureRect
export(NodePath) onready var slot5 = get_node(slot5) as TextureRect
export(NodePath) onready var slot6 = get_node(slot6) as TextureRect
export(NodePath) onready var slot7 = get_node(slot7) as TextureRect
export(NodePath) onready var slot_container = get_node(slot_container) as GridContainer

# Gameover popup paths
export(NodePath) onready var popup_score_label = get_node(popup_score_label) as Label
export(NodePath) onready var game_over_popup = get_node(game_over_popup) as Control
export(NodePath) onready var popup_next_button = get_node(popup_next_button) as Button
export(NodePath) onready var popup_retry_button = get_node(popup_retry_button) as Button
export(NodePath) onready var popup_indicator_label = get_node(popup_indicator_label) as Label
export(NodePath) onready var crowns = get_node(crowns) as TextureRect
export(NodePath) onready var gameover_anim = get_node(gameover_anim) as AnimationPlayer
export(NodePath) onready var celebration = get_node(celebration) as Sprite
export(NodePath) onready var audioplayer = get_node(audioplayer) as AudioStreamPlayer
export(NodePath) onready var net1_skills = get_node(net1_skills) as Label
export(NodePath) onready var coins = get_node(coins) as Label
##

# Instructions popup paths
export(NodePath) onready var animation_player = get_node(animation_player) as AnimationPlayer
export(NodePath) onready var instructions_popup = get_node(instructions_popup) as Control
export(NodePath) onready var instructions_sprite = get_node(instructions_sprite) as Sprite
##

# players data
export(Resource) var settings_data


var specific_positions = [
	Vector2(50, 50), 
	Vector2(450, 50), 
	Vector2(50, 250), 
	Vector2(450, 250), 
	Vector2(50, 450), 
	Vector2(450, 450), 
	Vector2(254, 575)
	]
	
var score = 0
var textures = []


func _ready():
	animation_player.play("level5_tutorial")
	textures = [layer1.texture, layer2.texture, layer3.texture, layer4.texture, layer5.texture, layer6.texture, layer7.texture]
	shuffle()
	position()

# To shuffle layers to be displayed
func shuffle():
	for i in range(specific_positions.size() - 1, 0, -1):
		var j = randi() % (i + 1)
		var temp = specific_positions[i]
		specific_positions[i] = specific_positions[j]
		specific_positions[j] = temp
##

# To set the position of layers to be displayed
func position():
	var nodes = []
	for child in get_children():
		if child is TextureRect:
			nodes.append(child)
		
	for i in range(min(specific_positions.size(), nodes.size())):
		var node = nodes[i]
		var position = specific_positions[i]
		position_texture_rect(node, position)
##
		
func position_texture_rect(node: TextureRect, position: Vector2):
	node.rect_position = position


# To check user's answer then display the gameover popup
func _on_submit_pressed():
	$AudioStreamPlayer.play()
	var i = 6
	if slot1.texture == textures[0] and slot2.texture == textures[1] and slot3.texture == textures[2] and slot4.texture == textures[3] and slot5.texture == textures[4] and slot6.texture == textures[5] and slot7.texture == textures[6]:
		popup_indicator_label.text = "Level Complete!"
		gameover_anim.play("win")
		celebration.visible = true
		audioplayer.play()
		score = 7
		if score == 7:
			crowns.texture = preload("res://resources/Game buttons/3_crowns.png")
			net1_skills.text = "Networking 1 skills: 10"
			coins.text = "+200"
		popup_score_label.text = "Score: " + str(score)
		popup_next_button.disabled = false
		score_validation()
	else:
		audioplayer.stream = preload("res://resources/soundtrack/game_over/losegamemusic.wav")
		audioplayer.play()
		gameover_anim.play("lose")
		popup_indicator_label.text = "Level Failed!"
		for child in slot_container.get_children():
			if child.texture == textures[i]:
				score += 1
			i -= 1
		if score == 0:
			crowns.texture = preload("res://resources/Game buttons/0_crowns.png")
			net1_skills.text = "Networking 1 skills: 0"
			coins.text = "+0"
		elif score >= 4 and score <= 6:
			crowns.texture = preload("res://resources/Game buttons/2_crowns.png")
			net1_skills.text = "Networking 1 skills: 0"
			coins.text = "+0"
		elif score <= 3:
			crowns.texture = preload("res://resources/Game buttons/1_crowns.png")
			net1_skills.text = "Networking 1 skills: 0"
			coins.text = "+0"
			
		popup_score_label.text = "Score: " + str(score)
		popup_next_button.disabled = true
	
	game_over_popup.visible = true
##

func _on_reload_pressed():
	var current_scene_path = get_tree().current_scene
	Load.load_scene(self,level5_scene)


func _on_retry_pressed():
	Load.load_scene(self,level5_scene)


func _on_tap_pressed():
	instructions_popup.visible = false
	instructions_sprite.visible = false


func _on_restart_pressed():
	Load.load_scene(self,level5_scene)

func score_validation():
	
	if settings_data.quick_game == "isplaying":
		popup_next_button.disabled = true
		popup_retry_button.disabled = true
		net1_skills.text = "Networking 1 skills: 0"
		if settings_data.reset_timer >= 10800:
			if score >= 4:
				var current_coins = settings_data.gold_coins
				var new_coins = current_coins+80
				settings_data.gold_coins = new_coins
				settings_data.reset_timer = 0
				settings_data.quick_game = "notplaying"
				SaveManager.save_game()
			elif score >= 5 and score <= 6:
				var current_coins = settings_data.gold_coins
				var new_coins = current_coins+90
				settings_data.gold_coins = new_coins
				settings_data.reset_timer = 0
				settings_data.quick_game = "notplaying"
				SaveManager.save_game()
			elif score == 7:
				var current_coins = settings_data.gold_coins
				var new_coins = current_coins+100
				coins.text = "+100"
				settings_data.gold_coins = new_coins
				settings_data.reset_timer = 0
				settings_data.quick_game = "notplaying"
				SaveManager.save_game()
			else:
				settings_data.reset_timer = 0
				settings_data.quick_game = "notplaying"
				SaveManager.save_game()
		else:
			coins.text = "+0"
			settings_data.quick_game = "notplaying"
			SaveManager.save_game()
			
	elif settings_data.level5 > 0:
		net1_skills.text = "Networking 1 skills: 0"
		coins.text = "+0"
		return
		
	else:
		if score == 0:
			return
		elif score <= 4:
			settings_data.crowns += 1
			var current_coins = settings_data.gold_coins
			var new_coins = current_coins+80
			
			var skills = settings_data.net1_skills
			var update_skills = skills+10
			settings_data.reset_timer = 10800.18888
			settings_data.gold_coins = new_coins
			settings_data.net1_skills = update_skills
			settings_data.level5 = score
			SaveManager.save_game()
		elif score >= 5 and score <= 6:
			settings_data.crowns += 2
			var current_coins = settings_data.gold_coins
			var new_coins = current_coins+90
			var skills = settings_data.net1_skills
			var update_skills = skills+10
			settings_data.gold_coins = new_coins
			settings_data.net1_skills = update_skills
			settings_data.level5 = score
			settings_data.orange_shirt = "unlock"
			settings_data.reset_timer = 10800
			SaveManager.save_game()
		elif score == 7:
			settings_data.crowns += 3
			var current_coins = settings_data.gold_coins
			var new_coins = current_coins+100
			var skills = settings_data.net1_skills
			var update_skills = skills+10
			settings_data.gold_coins = new_coins
			settings_data.net1_skills = update_skills
			settings_data.level5 = score
			settings_data.orange_shirt = "unlock"
			settings_data.reset_timer = 10800		
			SaveManager.save_game()


func _on_next_pressed():
	Load.load_scene(self, "res://global/chapters/chapter1.tscn")


func _on_instruction_pressed():
	$popup_layer/instructions.visible = true
	instructions_sprite.visible = true
