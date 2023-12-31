extends Node2D

export(PackedScene) var this_scene
var score = 0
var json_file = "res://offline_levels/json/level1_questions.json"
var json_data = ""


export(NodePath) onready var object = get_node(object) as Node2D
export(NodePath) onready var notepad_content = get_node(notepad_content) as Label
export(NodePath) onready var main_scene = get_node(main_scene) as Node2D
export(NodePath) onready var notepad = get_node(notepad) as Sprite
export(NodePath) onready var score_label = get_node(score_label) as Label

# Gameover popup paths
export(NodePath) onready var popup_score_label = get_node(popup_score_label) as Label
export(NodePath) onready var game_over_popup = get_node(game_over_popup) as Control
export(NodePath) onready var popup_next_button = get_node(popup_next_button) as Button
export(NodePath) onready var pop_retry_button = get_node(pop_retry_button) as Button
export(NodePath) onready var popup_indicator_label = get_node(popup_indicator_label) as Label
export(NodePath) onready var crowns = get_node(crowns) as TextureRect
export(NodePath) onready var animationplayer = get_node(animationplayer) as AnimationPlayer
export(NodePath) onready var celebrate = get_node(celebrate) as Sprite
export(NodePath) onready var audioplayer = get_node(audioplayer) as AudioStreamPlayer
export(NodePath) onready var net1_skills = get_node(net1_skills) as Label
export(NodePath) onready var coins = get_node(coins) as Label
# Instructions popup paths
export(NodePath) onready var animation_player = get_node(animation_player) as AnimationPlayer
export(NodePath) onready var instructions_popup = get_node(instructions_popup) as Control
export(NodePath) onready var instructions_sprite = get_node(instructions_sprite) as Sprite
##

#saving_progress path
export (Resource) var setting_data

var home_scene = "res://scenes/main_screen/main_screen.tscn"
var level1_scene = "res://offline_levels/level1/level_1.tscn"

func _ready():
	# To play the animation in instruction popup
	setting_data.connect("changed", self, "_on_data_changed")
	animation_player.play("animation")
	##
	
	#for getting data in a JSON file and putting it in the json_data variable as dictionary
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
	##
	
	#for feeding labels with their corresponding content (1st Question only)
	var size = json_data.size() - 1
	var i = rand_range(0, size)
	var name = json_data[i]["name"]
	var type = json_data[i]["type"]
	var content = json_data[i]["content"]
	json_data.remove(i)
	object.type = type
	object.content = content
	notepad_content.text = object.content
	return json_data
	##
		
	
func spawn_new():
	# To create new questions
	while(json_data.size() != 1):
		print(json_data.size())
		var size = json_data.size() - 1
		var i = rand_range(0, size)
		var name = json_data[i]["name"]
		var type = json_data[i]["type"]
		var content = json_data[i]["content"]
		json_data.remove(i)
		
		var new_item = this_scene.instance() 
		if (new_item != null):
			main_scene.add_child(new_item)
			new_item.owner = main_scene
			new_item.position = Vector2(510, 726)
			new_item.type = type
			new_item.content = content
			notepad_content.text = new_item.content
		return json_data
	##
	
	notepad_content.text = ""
	notepad.queue_free()
	
	# To show popup and set its contents
	popup_score_label.text = "Score: " + score_label.text
	if int(score_label.text) >= 6:
		popup_next_button.disabled = false
		popup_indicator_label.text = "Level Complete!"
		if score == 6:
			crowns.texture = preload("res://resources/Game buttons/1_crowns.png")
			audioplayer.play()
			animationplayer.play("win")
			celebrate.visible = true
			net1_skills.text = "Networking 1 skills: 10"
			coins.text = "+70"
		elif score == 7:
			crowns.texture = preload("res://resources/Game buttons/1_crowns.png")
			audioplayer.play()
			animationplayer.play("win")
			celebrate.visible = true
			net1_skills.text = "Networking 1 skills: 10"
			coins.text = "+80"
		elif score >= 8 and score <= 9:
			crowns.texture = preload("res://resources/Game buttons/2_crowns.png")
			audioplayer.play()
			animationplayer.play("win")
			celebrate.visible = true
			net1_skills.text = "Networking 1 skills: 10"
			coins.text = "+90"
		elif score == 10:
			audioplayer.play()
			animationplayer.play("win")
			celebrate.visible = true
			crowns.texture = preload("res://resources/Game buttons/3_crowns.png")
			net1_skills.text = "Networking 1 skills: 10"
			coins.text = "+200"
		_on_data_changed()
	else:
		popup_next_button.disabled = true
		animationplayer.play("lose")
		audioplayer.stream = preload("res://resources/soundtrack/game_over/losegamemusic.wav")
		audioplayer.play()
		popup_indicator_label.text = "Level Failed!"
		net1_skills.text = "Networking 1 skills: 0"
		coins.text = "+0"
		crowns.texture = preload("res://resources/Game buttons/0_crowns.png")
	game_over_popup.visible = true
	##


func _on_next_pressed():
	$"..".queue_free()
	Load.load_scene(self,"res://global/chapters/chapter1.tscn")

func _on_tap_pressed():
	instructions_popup.visible = false
	instructions_sprite.visible = false
	
func _on_data_changed():
	#update coins
	if setting_data.quick_game == "isplaying":
		net1_skills.text = "Networking 1 skills: 0"
		pop_retry_button.disabled = true
		popup_next_button.disabled = true
		if setting_data.reset_timer >= 900:
			if score >= 7 and score <= 9:
				var coins = setting_data.gold_coins
				var current = coins+100
				setting_data.gold_coins = current
				setting_data.reset_timer = 0
				setting_data.quick_game = "notplaying"
				SaveManager.save_game()
			elif score == 10:
				var coins = setting_data.gold_coins
				var current = coins+100
				coins.text = "+100"
				setting_data.reset_timer = 0
				setting_data.gold_coins = current
				setting_data.quick_game = "notplaying"
				SaveManager.save_game()
			else:
				setting_data.reset_timer = 0
				coins.text = "+0"
				setting_data.quick_game = "notplaying"
				SaveManager.save_game()
				
		else:
			coins.text = "+0"
			setting_data.quick_game = "notplaying"
			SaveManager.save_game()
			
	elif setting_data.level1 > 0:
		net1_skills.text = "Networking 1 skills: 0"
		coins.text = "+0"
		return
	else:
		if score >= 6 and score <= 9:
			setting_data.crowns = 2
			setting_data.level1 = score
			var coins = setting_data.gold_coins
			var current = coins+100
			var skills = setting_data.net1_skills
			var update_skills = skills+10
			setting_data.net1_skills = update_skills
			setting_data.gold_coins = current
			setting_data.reset_timer = 900
			SaveManager.save_game()			
		elif score == 10:
			setting_data.crowns = 3
			var coins = setting_data.gold_coins
			var current = coins+200
			var skills = setting_data.net1_skills
			var update_skills = skills+10
			setting_data.net1_skills = update_skills
			setting_data.gold_coins = current
			setting_data.level1 = score
			setting_data.reset_timer = 900
			SaveManager.save_game()
			
func _on_retry_pressed():
	get_tree().change_scene("res://offline_levels/level1/level_1.tscn")


func _on_instruction_pressed():
	$"../popup_layer/instructions".visible = true
	instructions_sprite.visible = true
