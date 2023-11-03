extends Control


export(PackedScene) var letter_scene
export(PackedScene) var blank_scene
export(Resource) var settings_data
var json_file = "res://offline_levels/json/level2_questions.json"
var json_data = ""
var answer
var score = 0
var i
export(NodePath) onready var clue_label = get_node(clue_label) as Label
export(NodePath) onready var score_label = get_node(score_label) as Label
export(NodePath) onready var letter_container = get_node(letter_container) as GridContainer
export(NodePath) onready var blank_container = get_node(blank_container) as GridContainer
export(NodePath) onready var submit_button = get_node(submit_button) as Button

# Gameover popup paths
export(NodePath) onready var popup_score_label = get_node(popup_score_label) as Label
export(NodePath) onready var game_over_popup = get_node(game_over_popup) as Control
export(NodePath) onready var popup_next_button = get_node(popup_next_button) as Button
export(NodePath) onready var pop_retry_button = get_node(pop_retry_button) as Button
export(NodePath) onready var popup_indicator_label = get_node(popup_indicator_label) as Label
export(NodePath) onready var crowns = get_node(crowns) as TextureRect
export(NodePath) onready var animation_player = get_node(animation_player) as AnimationPlayer
export(NodePath) onready var celebrate = get_node(celebrate) as Sprite
export(NodePath) onready var audioplayer = get_node(audioplayer) as AudioStreamPlayer
export(NodePath) onready var tutorial_player = get_node(tutorial_player) as AnimationPlayer
##

# Instructions popup paths
export(NodePath) onready var instructions_popup = get_node(instructions_popup) as Control
export(NodePath) onready var instructions_sprite = get_node(instructions_sprite) as Sprite
##

var home_scene = "res://scenes/main_screen/main_screen.tscn"
var level2_scene = "res://offline_levels/level2/level2.tscn"

func _ready():
	tutorial_player.play("level2_tutorial")
	# To store JSON Contents into file variable
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
	
	i = 0

	var scrambled = json_data[i]["scrambled"]
	var clue = json_data[i]["clue"]
	answer = json_data[i]["answer"]
	clue_label.text = clue
	
	var x = 0
	for child in letter_container.get_children():
		if child is Button:
			child.text = scrambled[x]
			x += 1
	
	give_hints(answer)
	
	return json_data
	
	
func _process(delta):
	# To enable the submit button when all blanks are filled and to disable if not
	var blank_counts = blank_container.get_child_count()
	var last_blank = blank_container.get_child(blank_counts - 1)
	if last_blank != null:
		if last_blank.text != "_":
			submit_button.disabled = false
		else:
			submit_button.disabled = true
	##


func _on_clear_pressed():
	# To clear every blank when Clear Button is Clicked
	$"../submit2".stream = preload("res://resources/soundtrack/level/clear_btn.wav")
	$"../submit2".play()
	for child in blank_container.get_children():
		child.text = "_"
	for child in letter_container.get_children():
		child.disabled = false
	##


func _on_submit_pressed():
	# To check the user's answer
	i += 1
	$"../submit2".play()
	var user_answer = ""
	for child in blank_container.get_children():
		user_answer = user_answer + child.text
	if user_answer == answer:
		score += 1
		score_label.text = str(score)
		$"../animation_player/AnimationPlayer/correct".visible = true
		$"../animation_player/ColorRect".visible = true
		$"../animation_player/AnimationPlayer".play("win")
		yield(get_tree().create_timer(1.0), "timeout")
		$"../animation_player/AnimationPlayer/correct".visible = false
		$"../animation_player/ColorRect".visible = false
	##
	else:
		$"../animation_player/ColorRect".visible = true
		$"../animation_player/AnimationPlayer/correct".texture = preload("res://resources/Game buttons/cat_incorrect.png")
		$"../animation_player/AnimationPlayer/correct".visible = true
		$"../animation_player/AnimationPlayer".play("win")
		yield(get_tree().create_timer(1.0), "timeout")
		$"../animation_player/AnimationPlayer/correct".visible = false
		$"../animation_player/ColorRect".visible = false
	
	for child in blank_container.get_children():
		child.queue_free()
	for child in letter_container.get_children():
		child.queue_free()
	clue_label.text = ""
	
	display_next()
	give_hints(answer)
	
func display_next():
# To display the next question
	while (i < 5):
		var scrambled = json_data[i]["scrambled"]
		var clue = json_data[i]["clue"]
		answer = json_data[i]["answer"]
		clue_label.text = clue
		var x = 0
		for Char in scrambled:
			var new_letter = letter_scene.instance()
			var new_blank = blank_scene.instance()
			if (new_blank != null):
				blank_container.add_child(new_blank)
				new_blank.text = "_"
				new_blank.rect_min_size = Vector2(100, 100)
				new_blank.letter_container = letter_container
				letter_container.add_child(new_letter)
				new_letter.text = scrambled[x]
				new_letter.rect_min_size = Vector2(100, 100)
				new_letter.blank_container = blank_container
				x += 1
		return i
	##
	
func give_hints(answer):
	var counter = 0
	var random_number
	while counter != 3:
		random_number = int(rand_range(0, answer.length() - 1))
		blank_container.get_child(random_number).text = answer[random_number]
		for letter in letter_container.get_children():
			if letter.text.to_lower() == answer[random_number].to_lower():
				letter.disabled = true
				break
		counter += 1
		
	# To show popup and set its contents
	popup_score_label.text = "Your Score: " + score_label.text + " / 5"
	if int(score_label.text) >= 4:
		popup_next_button.disabled = false
		popup_indicator_label.text = "Level Complete!"
		if score == 4:
			crowns.texture = preload("res://resources/Game buttons/2_crowns.png")
			animation_player.play("win")
			audioplayer.play()
			celebrate.visible = true
		elif score == 5:
			crowns.texture = preload("res://resources/Game buttons/3_crowns.png")
			animation_player.play("win")
			celebrate.visible = true
			audioplayer.play()
		score_validation()
	else:
		if score <= 3:
			crowns.texture = preload("res://resources/Game buttons/1_crowns.png")
			animation_player.play("lose")
			audioplayer.stream = preload("res://resources/soundtrack/game_over/losegamemusic.wav")
			audioplayer.play()
		elif score == 0:
			crowns.texture = preload("res://resources/Game buttons/0_crowns.png")
		popup_next_button.disabled = true
		popup_indicator_label.text = "Level Failed!"
		animation_player.play("lose")
		audioplayer.stream = preload("res://resources/soundtrack/game_over/losegamemusic.wav")
		audioplayer.play()
	game_over_popup.visible = true
	##


func _on_tap_pressed():
	instructions_popup.visible = false
	instructions_sprite.visible = false


func _on_next_pressed():
	$"..".queue_free()
	Load.load_scene(self, "res://global/chapters/chapter1.tscn")

func score_validation():
	if settings_data.level2 == 5:
		settings_data.level2 = score
		SaveManager.save_game()
	if settings_data.quick_game == "isplaying":
		pop_retry_button.disabled = true
		popup_next_button.disabled = true
		if settings_data.reset_timer >= 10800:
			if score == 4:
				var current_coins = settings_data.gold_coins
				var new_coins = current_coins+90
				settings_data.gold_coins = new_coins
				settings_data.quick_game = "notplaying"
				settings_data.reset_timer = 0
				SaveManager.save_game()
			elif score == 5:
				var current_coins = settings_data.gold_coins
				var new_coins = current_coins+100
				settings_data.gold_coins = new_coins
				settings_data.quick_game = "notplaying"
				settings_data.reset_timer = 0
				SaveManager.save_game()
			else:
				settings_data.quick_game = "notplaying"
				settings_data.reset_timer = 0
				SaveManager.save_game()
		else:
			settings_data.quick_game = "notplaying"
			SaveManager.save_game()
	else:
		if score == 4:
			settings_data.crowns += 2
			var current_coins = settings_data.gold_coins
			var new_coins = current_coins+90
			var skills = settings_data.net1_skills
			var update_skills = skills+10
			settings_data.crowsn+=2
			settings_data.blue_shirt = "unlock"
			settings_data.girl_pants = "unlock"
			settings_data.gold_coins = new_coins
			settings_data.net1_skills = update_skills
			settings_data.level2 = score
			settings_data.reset_timer = 10800
			SaveManager.save_game()
		elif score <= 3:
			settings_data.level2 = score
			SaveManager.save_game()
			pass
		elif score == 5:
			var current_coins = settings_data.gold_coins
			var new_coins = current_coins+100
			var skills = settings_data.net1_skills
			var update_skills = skills+10
			settings_data.blue_shirt = "unlock"
			settings_data.girl_pants = "unlock"
			settings_data.gold_coins = new_coins
			settings_data.net1_skills = update_skills
			settings_data.crowns+=3
			settings_data.reset_timer = 10800
			settings_data.level2 = score
			SaveManager.save_game()
	


func _on_instruction_pressed():
	$"../popup_layer/instructions".visible = true
