extends CanvasLayer

export (Resource) var settings_data
var http_request : HTTPRequest = HTTPRequest.new()
const SERVER_URL = "https://nwork.slarenasitsolutions.com/authentication.php"
const SERVER_HEADERS = ["Content-Type: application/x-www-form-urlencoded", "Cache-Control: max-age=0"]
var request_queue : Array = []
var is_requesting : bool = false
var pusername = ""
var password = ""
var cpassword =""
var result = ""

func _ready():
	# Connect our request handler:
	add_child(http_request)
	print(settings_data)
	http_request.connect("request_completed", self, "_http_request_completed")
	$sign_in_btn.connect("pressed", self, "_add_user")
	$"../signup_success/ok_btn".connect("pressed", self, "_change_scene")
		
func _process(_delta):
	# Check if we have pending requests in the queue:
	if !request_queue.empty() and !is_requesting:
		var request = request_queue.pop_front()
		_send_request(request)

func _http_request_completed(result, response_code, headers, body):
	is_requesting = false
	# Re-enable UI elements here (e.g., $signup_btn)
	
	if result != HTTPRequest.RESULT_SUCCESS:
		$"../warning".visible = true
		$"../warning/warning2".text = "No Internet Connection"
		return

	var response_body = body.get_string_from_utf8()

	if response_body.empty():
		printerr("Empty response body")
		return

	var response = parse_json(response_body)
		
	if "error" in response and response["error"] == "email_already_exists":
		# Display a message to the user indicating that the email already exists
		$"../warning".visible = true
		$"../warning/warning2".text = "Email already exists. Please use a different email."
		$s_username/s_username.text = ""
		$s_password/s_password.text = ""
		$_confirmpassword/cpassword.text = ""
		return

	if result == HTTPRequest.RESULT_SUCCESS:
		var _response_data = body.get_string_from_utf8()
		_change_scene()
		print("Response Data:", _response_data)
		
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

func _add_user():
	# Disable relevant UI elements here (e.g., $signup_btn)

	var username_input = $s_username/s_username
	var password_input = $s_password/s_password
	var cpassword_input = $_confirmpassword/cpassword

	var username = username_input.text
	var user_password = password_input.text
	var cpassword = cpassword_input.text

	if user_password == cpassword:
		# Check if the email contains either '@gmail.com' or '@bulsu.edu.ph'
		if username.find("@gmail.com") != -1 or username.find("@bulsu.edu.ph") != -1:
			var command = "add_user"
			var data = {"username": username, "password": user_password}
			request_queue.push_back({"command": command, "data": data})
			settings_data.email = username
		else:
			$"../warning".visible = true
			$"../warning/warning2".text = "Invalid email format."
	else:
		$"../warning".visible = true
		$"../warning/warning2".text = "Password didn't match."

		
func _change_scene():
	$"..".queue_free()
	Load.load_scene(self,"res://scenes/create_account/create_account.tscn")

func _on_ok_btn_pressed():
	pass # Replace with function body.

	
