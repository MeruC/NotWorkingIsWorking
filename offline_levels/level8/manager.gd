extends Control

export(NodePath) onready var user_input = get_node(user_input) as LineEdit
export(NodePath) onready var submit = get_node(submit) as Button
export(NodePath) onready var question_label = get_node(question_label) as Label
export(NodePath) onready var timer = get_node(timer) as Timer
export(NodePath) onready var remaining_time = get_node(remaining_time) as Label
export(NodePath) onready var questionNumber_label = get_node(questionNumber_label) as Label
export(NodePath) onready var perQuestion_popup = get_node(perQuestion_popup) as Control
export(NodePath) onready var perQuestion_title = get_node(perQuestion_title) as Label
export(NodePath) onready var perQuestion_content = get_node(perQuestion_content) as Label
export(NodePath) onready var gameover_popup = get_node(gameover_popup) as Control
export(NodePath) onready var gameover_indicator = get_node(gameover_indicator) as Label
export(NodePath) onready var gameover_score = get_node(gameover_score) as Label
export(NodePath) onready var gameover_next = get_node(gameover_next) as Button
export(NodePath) onready var gameover_retry = get_node(gameover_retry) as Button
export(NodePath) onready var score_display = get_node(score_display) as Label
export(NodePath) onready var crowns = get_node(crowns) as TextureRect
export(NodePath) onready var audioplayer = get_node(audioplayer) as AudioStreamPlayer
export(NodePath) onready var gameover_anim = get_node(gameover_anim) as AnimationPlayer
export(NodePath) onready var celebration = get_node(celebration) as Sprite
export(NodePath) onready var tutorial_player = get_node(tutorial_player) as AnimationPlayer
export(NodePath) onready var instruction_sprite = get_node(instruction_sprite) as Sprite
export(Resource) var settings_data

var score = 0
var question_number = 0

func _ready():
	tutorial_player.play("level8_tutorial")

func _process(delta):
	display_time()

func display_time():
	remaining_time.text = str(int(timer.time_left))

func next_question():
	generate_question()
	set_timer()
	question_number += 1
	questionNumber_label.text = str(question_number)
	user_input.text = ""
	
func set_timer():
	timer.start(60)
	

# To generate questions and display it in a label
func generate_question():
	var answer
	var question
	var type = int(rand_range(0,2))
	
	if type == 0:
		question = generate_decimal()
		answer = decimalToBinary(question)
		user_input.placeholder_text = "01101101"
	else:
		question = generate_binary()
		answer = binaryToDecimal(question)
		user_input.placeholder_text = "255"
		
	question_label.text = str(question)
	question_label.answer = str(answer)
	question_label.type = type
##

# To generate a decimal value
func generate_decimal():
	var decimal = int(rand_range(1, 256))
	return decimal
##

# To compute the binary equivalent of the generated decimal value
func decimalToBinary(decimal_value: int) -> String:
	var binary_string = ""
	
	while decimal_value > 0:
		var remainder = decimal_value % 2
		binary_string = str(remainder) + binary_string
		decimal_value = decimal_value / 2
	if binary_string.length() < 8:
		var zerosToAdd = 8 - binary_string.length()
		var zeros = ""
		for i in range(zerosToAdd):
			zeros += "0"
		binary_string = zeros + binary_string
	print(binary_string)
	return binary_string
##

# To generate a binary value
func generate_binary():
	var binary = []
	var i = 0
	while i < 8:
		binary.append(str(int(rand_range(0,2))))
		i += 1
	binary = arrayToString(binary)
	return binary
##

# To compute the decimal equivalent of the generated binary value
func binaryToDecimal(binary_string: String) -> int:
	var decimal_value = 0
	var binary_length = binary_string.length()
	
	for i in range(binary_length):
		var bit = int(binary_string[binary_length - 1 - i])
		decimal_value += bit * pow(2, i)
		
	return decimal_value
##

# To combine each element of an array into a single array
func arrayToString(input: Array) -> String:
	var result = ""
	for i in range(input.size()):
		result += str(input[i])
	return result
##

# To check the user input
func _on_submit_pressed():
	if user_input.text == question_label.answer:
		score += int(timer.time_left)
		score_display.text = str(score)
		correct_popup()
		timer.stop()
	else:
		user_input.text = ""
		user_input.placeholder_text = "Please try again"
##

func _on_Timer_timeout():
	timeout_popup()

# To indicate that the user's answer is correct
func correct_popup():
	perQuestion_title.text = "Correct!"
	perQuestion_content.text = "Gained Score: " + str(int(timer.time_left))
	perQuestion_popup.visible = true
##

# To indicate that time ran out
func timeout_popup():
	perQuestion_title.text = "Time's up"
	perQuestion_content.text = "Gained Score: " + str(int(timer.time_left))
	perQuestion_popup.visible = true
##

func _on_instructions_hide():
	next_question()

func _on_tap_pressed():
	perQuestion_popup.visible = false
	if question_number != 10:
		next_question()
	else:
		calculate_score()

# To calculate score then display the gameover popup
func calculate_score():
	if score < 50:
		crowns.texture = preload("res://resources/Game buttons/0_crowns.png")
		gameover_anim.play("lose")
		audioplayer.stream = preload("res://resources/soundtrack/game_over/losegamemusic.wav")
		audioplayer.play()
		gameover_indicator.text = "Level Failed"
		gameover_score.text = "Your Score: " + str(score)
		gameover_next.disabled = true
		
	if score >= 50 and score <= 99:
		crowns.texture = preload("res://resources/Game buttons/1_crowns.png")
		gameover_anim.play("win")
		audioplayer.play()
		gameover_indicator.text = "Level Complete"
		gameover_score.text = "Your Score: " + str(score)
		crowns.texture = preload("res://resources/Game buttons/1_crowns.png")
		gameover_next.disabled = false
		score_validation()
		
	elif score >= 100 and score <= 149:
		crowns.texture = preload("res://resources/Game buttons/2_crowns.png")
		audioplayer.play()
		celebration.visible = true
		gameover_indicator.text = "Level Complete!"
		gameover_anim.play("win")
		gameover_score.text = "Your Score: " + str(score)
		crowns.texture = preload("res://resources/Game buttons/2_crowns.png")
		gameover_next.disabled = false
		score_validation()
	elif score >= 150:
		gameover_anim.play("win")
		crowns.texture = preload("res://resources/Game buttons/3_crowns.png")
		audioplayer.play()
		celebration.visible = true
		gameover_indicator.text = "Level Complete!"
		gameover_score.text = "Your Score: " + str(score)
		crowns.texture = preload("res://resources/Game buttons/3_crowns.png")
		gameover_next.disabled = false
		score_validation()
		
	gameover_popup.visible = true
##

func score_validation():
	if settings_data.level8 > 0:
		return
	if settings_data.quick_game == "isplaying":
		gameover_retry.disabled = true
		gameover_next.disabled = true
		if settings_data.reset_timer >= 10800:
			if score >= 30 and score<=399:
				var current_coins = settings_data.gold_coins
				var new_coins = current_coins+100
				settings_data.reset_timer = 0
				settings_data.gold_coins = new_coins
				settings_data.quick_game = "notplaying"
				SaveManager.save_game()
			elif score >= 400:
				var current_coins = settings_data.gold_coins
				var new_coins = current_coins+200
				settings_data.gold_coins = new_coins
				settings_data.reset_timer = 0
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
		if score >= 30 and score>0:
			var current_coins = settings_data.gold_coins
			var new_coins = current_coins+100
			var skills = settings_data.net1_skills
			var update_skills = skills+30
			settings_data.crowns += 2
			settings_data.gold_coins = new_coins
			settings_data.net1_skills = update_skills
			settings_data.level8 = score
			settings_data.reset_timer = 10800.18888
			SaveManager.save_game()
		elif score >= 400:
			var current_coins = settings_data.gold_coins
			var new_coins = current_coins+200
			var skills = settings_data.net1_skills
			settings_data.crowns += 3
			var update_skills = skills+30
			settings_data.formal_attire = "unlock"
			settings_data.girl_casual = "unlock"
			settings_data.gold_coins = new_coins
			settings_data.net1_skills = update_skills
			settings_data.level8 = score
			settings_data.reset_timer = 10800.18888
			SaveManager.save_game()
		else:
			return


func _on_instruction_pressed():
	$popup_layer/instructions.visible = true
	instruction_sprite.visible = true

func _on_next_pressed():
	Load.load_scene(self,"res://global/chapters/chapter1.tscn")
