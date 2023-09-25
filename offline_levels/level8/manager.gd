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
export(NodePath) onready var score_display = get_node(score_display) as Label

var score = 0
var question_number = 0

func _process(delta):
	display_time()

func display_time():
	remaining_time.text = str(int(timer.time_left))

func next_question():
	generate_question()
	set_timer()
	question_number += 1
	questionNumber_label.text = str(question_number)
	
func set_timer():
	timer.start(30)
	

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
	perQuestion_title.text = "Time Ran Out"
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
	if score >= 50:
		gameover_indicator.text = "Level Complete!"
		gameover_score.text = "Your Score: " + score
		gameover_next.disabled = false
	else:
		gameover_indicator.text = "Level Failed"
		gameover_score.text = "Your Score: " + str(score)
		gameover_next.disabled = true
		
	gameover_popup.visible = true
##
