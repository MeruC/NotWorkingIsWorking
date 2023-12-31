extends CanvasLayer

var http_request : HTTPRequest = HTTPRequest.new()
const SERVER_URL = "https://nwork.slarenasitsolutions.com/authentication.php"
const SERVER_HEADERS = ["Content-Type: application/x-www-form-urlencoded", "Cache-Control: max-age=0"]
var request_queue : Array = []
var is_requesting : bool = false
var pusername = ""
var password = ""

export (Resource) var settings_data 

func _ready():
	# Connect our request handler:
	add_child(http_request)
	http_request.connect("request_completed", self, "_http_request_completed")
	$login_enter_btn.connect("pressed", self, "_authenticate")

func _process(_delta):
	# Check if we have pending requests in the queue:
	if !request_queue.empty() and !is_requesting:
		var request = request_queue.pop_front()
		_send_request(request)

func _http_request_completed(result, response_code, headers, body):
	var nickname
	is_requesting = false
	if result != HTTPRequest.RESULT_SUCCESS:
		$"../warning".visible = true
		$"../warning/warning2".text = "No Internet Connection"
		$username/username.text = ""
		$password2.text = ""
		$login_enter_btn.disabled = false
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
		if "authenticated" in response_dict:
			if response_dict["authenticated"] == true:
				 # Authentication was successful, show a success message with the nickname
				nickname = response_dict["nickname"]
				settings_data.email = nickname
				SaveManager.save_game()
				$".".visible = false
				$"../retrieve_savedata".visible = true
				$login_enter_btn.disabled = false
			else:
				# Authentication failed, check if the response contains "account_exists" key
				if "account_exists" in response_dict and response_dict["account_exists"] == false:
					print("Account doesn't exist")
					$login_enter_btn.disabled = false
				else:
					$"../warning".visible = true
					$"../warning/warning2".text = "email/password incorrect"
					$login_enter_btn.disabled = false
					
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

func _authenticate():
	$login_enter_btn.disabled = true
	var username_input = $username/username
	var password_input = $password2

	var username = username_input.text
	var user_password = password_input.text

	var command = "authenticate"
	var data = {"username": username, "password": user_password}
	request_queue.push_back({"command": command, "data": data})

func _on_forgot_password_pressed():
	$".".visible = false
	$"../check_account".visible = true
