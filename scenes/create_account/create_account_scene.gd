extends CanvasLayer

var http_request : HTTPRequest = HTTPRequest.new()
const SERVER_URL = "https://nwork.slarenasitsolutions.com/authentication.php"
const SERVER_HEADERS = ["Content-Type: application/x-www-form-urlencoded", "Cache-Control: max-age=0"]
var request_queue : Array = []
var is_requesting : bool = false
export( Resource ) var settings_data

func _ready():
	add_child(http_request)
	http_request.connect("request_completed", self, "_http_request_completed")
	
func _process(_delta):
	# Check if we have pending requests in the queue:
	if !request_queue.empty() and !is_requesting:
		var request = request_queue.pop_front()
		_send_request(request)
		
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

func update_name():
	var email = settings_data.email
	var name = $Username/LineEdit.text
	var command = "update_name"
	var data = {"email": email, "name": name}
	request_queue.push_back({"command": command, "data": data})

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
		
func _on_confirm_pressed():
	var nickname_input = $Username/LineEdit
	var nickname = nickname_input.text
	update_name()
	if nickname == "":
		$Label.text = "Invalid nickname"
	else:
		# Update the player_name property of settings_data
		var player_name = $Username/LineEdit.text
		settings_data.player_name = $Username/LineEdit.text
		settings_data.rank = "rookie"
		settings_data.account_status = "old"
		settings_data.net1_skills = 0
		settings_data.net2_skills = 0
		# Hide elements and perform other actions as needed
		$".".visible = false
		$"../select_gender".visible = true
		SaveManager.save_game()
		$"../AnimationPlayer".play("male_anim")
