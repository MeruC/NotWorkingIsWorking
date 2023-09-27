extends Control

export(String) var json_code
var json_data = ""
var score = 0
var i = 0

#database_connection
var http_request : HTTPRequest = HTTPRequest.new()
const SERVER_URL = "http://192.168.100.247:8080/authentication.php"
const SERVER_HEADERS = ["Content-Type: application/x-www-form-urlencoded", "Cache-Control: max-age=0"]
export (Resource) var settings_data
var request_queue : Array = []
var is_requesting : bool = false
var pusername = ""
var password = ""

export(NodePath) onready var instructions = find_node("instructions")
export(NodePath) onready var game_over = find_node("game_over")
export(NodePath) onready var level_name = find_node("level_name")
export(NodePath) onready var minute = find_node("minute")
export(NodePath) onready var second = find_node("second")
export(NodePath) onready var timer = find_node("Timer")
export(NodePath) onready var current_item = find_node("current_item")
export(NodePath) onready var total_item = find_node("total_item")
export(NodePath) onready var question_content = find_node("question_content")
export(NodePath) onready var choices_container = find_node("choices")
export(NodePath) onready var choice1 = find_node("choice")
export(NodePath) onready var choice2 = find_node("choice2")
export(NodePath) onready var choice3 = find_node("choice3")
export(NodePath) onready var choice4 = find_node("choice4")

var main_screen = "res://scenes/main_screen/main_screen.tscn"

func _ready():
	add_child(http_request)
	var json_file = "res://online_mode/json/" + json_code + ".json"
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
	
	level_name.text = json_data["level_name"]
	total_item.text = str(json_data["questions"].size())
	timer.wait_time = float(json_data["time"])
	display_question()
	
func _process(delta):
	set_time()
	if !request_queue.empty() and !is_requesting:
		var request = request_queue.pop_front()
		_send_request(request)
	
func set_time():
	minute.text = str(int(timer.time_left / 60))
	second.text = str("%02d" % (int(timer.time_left) % 60))
	
func display_question():
	current_item.text = str(i + 1)
	question_content.text = json_data["questions"][i]["question"]
	question_content.answer = json_data["questions"][i]["answer"]
	
	for child in choices_container.get_children():
		child.text = ""
	
	var choices = []
	choices.append(json_data["questions"][i]["answer"])
	while choices.size() != 4:
		var number = rand_range(0, json_data["questions"].size())
		if json_data["questions"][number]["answer"] in choices:
			pass
		else:
			choices.append(json_data["questions"][number]["answer"])
	choices.shuffle()
	var counter = 0
	for child in choices_container.get_children():
		child.text = choices[counter]
		counter += 1
	i += 1

func show_gameover():
	game_over.find_node("user_score").text = str(score)
	game_over.find_node("total_items").text = total_item.text
	timer.paused = true
	game_over.visible = true

func _on_Timer_timeout():
	show_gameover()

func _on_start_pressed():
	instructions.visible = false
	timer.start()

func _on_choice_pressed():
	if choice1.text == question_content.answer:
		score += 1
	print(str(score))
	if current_item.text != total_item.text:
		display_question()
	else:
		show_gameover()

func _on_choice2_pressed():
	if choice2.text == question_content.answer:
			score += 1
	print(str(score))
	if current_item.text != total_item.text:
		display_question()
	else:
		show_gameover()


func _on_choice3_pressed():
	if choice3.text == question_content.answer:
			score += 1
	print(str(score))
	if current_item.text != total_item.text:
		display_question()
	else:
		show_gameover()


func _on_choice4_pressed():
	if choice4.text == question_content.answer:
			score += 1
	print(str(score))
	if current_item.text != total_item.text:
		display_question()
	else:
		show_gameover()


func _on_exit_pressed():
	addScore()

func _http_request_completed(result, response_code, headers, body):
	is_requesting = false
	# Re-enable UI elements here (e.g., $signup_btn)
	
	if result != HTTPRequest.RESULT_SUCCESS:
		printerr("Error with connection: " + str(result))
		return

	var response_body = body.get_string_from_utf8()

	if response_body.empty():
		printerr("Empty response body")
		return

	var response = parse_json(response_body)

	if result == HTTPRequest.RESULT_SUCCESS:
		var _response_data = body.get_string_from_utf8()
		print("Response Data:", _response_data)

	if "response" in response and typeof(response["response"]) == TYPE_DICTIONARY:
		var response_dict = response["response"]
		if "authenticated" in response_dict and response_dict["authenticated"] == true:
			# Authentication was successful, redirect to the main screen
			Load.load_scene(self,"res://scenes/main_screen/main_screen.tscn")
		else:
			# Authentication failed, you can show an error message
			print("Authentication failed")
	
	if !request_queue.empty():
		var next_request = request_queue.pop_front()
		_send_request(next_request)

func _send_request(request : Dictionary):
	# Check if a request is already in progress
	if is_requesting:
		# If a request is already in progress, add the request to the queue
		request_queue.push_back(request)
		return

	is_requesting = true

	var client = HTTPClient.new()
	var data = client.query_string_from_dict({"data" : JSON.print(request['data'])})
	var body = "command=" + request['command'] + "&" + data

	# Make request to the server:
	var err = http_request.request(SERVER_URL, SERVER_HEADERS, false, HTTPClient.METHOD_POST, body)

	# Check if there were problems:
	if err != OK:
		printerr("HTTPRequest error: " + String(err))
		return

func addScore():
	var username = settings_data.email
	var scores = score
	var table_name = json_data["level_name"]
	var data = {
		"command": "upload_score",
		"username": username,
		"scores": scores,
		"table_name": table_name
	}
	print(data)
	var command = "upload_score"
	request_queue.push_back({"command": command, "data": data})
	
	# Handle the submission process (e.g., show a success message)
	print("Score submitted successfully.")
