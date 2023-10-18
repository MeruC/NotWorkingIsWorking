extends Control

var http_request: HTTPRequest = HTTPRequest.new()
const SERVER_URL = "https://nwork.slarenasitsolutions.com/authentication.php"
const SERVER_HEADERS = ["Content-Type: application/x-www-form-urlencoded", "Cache-Control: max-age=0"]
var request_queue: Array = []
var is_requesting: bool = false
var levelname = ""
var result = ""
var request_done = 0

# This script is for directing users into another scene
var previous_scene = "res://online_mode/level_create_Menu/level_create.tscn"
var levels_folder = "res://online_mode/saved_levels/"
var json_folder = "res://online_mode/json/"
onready var level_scene = $HBoxContainer/code

export(NodePath) onready var textfield = get_node(textfield) as LineEdit
export(NodePath) onready var error_popup = get_node(error_popup) as Control

func _ready():
	add_child(http_request)
	http_request.connect("request_completed", self, "_http_request_completed")

func _on_back_pressed():
	Load.load_scene(self, previous_scene)

func _on_join_pressed():
	$loading_scrreen.visible = true
	$loading_scrreen/AnimationPlayer.play("loading")
	level_scene = textfield.text.to_upper() + ".tscn"
	var full_path = levels_folder + level_scene
	get_file()
	var file = File.new()
	if file.open(full_path, File.READ) == OK:
		file.close()
		Load.load_scene(self, full_path)

func _on_continue_pressed():
	error_popup.visible = false

func _process(_delta):
	# Check if we have pending requests in the queue:
	if !request_queue.empty() and !is_requesting:
		var request = request_queue.pop_front()
		_send_request(request)

func _http_request_completed(result, response_code, headers, body):
	is_requesting = false
	if result != HTTPRequest.RESULT_SUCCESS:
		printerr("Error with connection: " + str(result))
		return

	var response_body = body.get_string_from_utf8()

	if response_body.empty():
		printerr("Empty response body")
		return

	var response = parse_json(response_body)

	if result == HTTPRequest.RESULT_SUCCESS:
		print("Response Data:", response_body)  # Print the response data

		if response_body == "Failed to download file from FTP server":
			result = "failed"
			return

		if "game_code" in response_body:
			# Save the response as a JSON file
			var newJsonFilePath = "res://online_mode/json/" + textfield.text.to_upper() + ".json"
			var jsonFile = File.new()
			if jsonFile.open(newJsonFilePath, File.WRITE) == OK:
				jsonFile.store_string(response_body)
				jsonFile.close()
				request_done = 2
				print("JSON file saved as:", newJsonFilePath)
			else:
				printerr("Failed to save the JSON file")
		else:
			# Save the response as a new file
			var newFilePath = "res://online_mode/saved_levels/" + textfield.text.to_upper() + ".tscn"
			var file = File.new()
			if file.open(newFilePath, File.WRITE) == OK:
				file.store_string(response_body)
				file.close()
				request_done = 1
				get_json_file()
				print("File saved as:", newFilePath)
				$loading_scrreen/AnimationPlayer.stop()
				$loading_scrreen.visible = false
				$CanvasLayer/dialog_box.visible = true
				$CanvasLayer/dialog_box/ColorRect/VBoxContainer/message.text = "The level has been successfully downloaded."
			else:
				printerr("Failed to save the file")

func _send_request(request: Dictionary):
	var client = HTTPClient.new()
	var data = client.query_string_from_dict({"data": JSON.print(request['data'])})
	var body = "command=" + request['command'] + "&" + data

	# Make request to the server:
	var err = http_request.request(SERVER_URL, SERVER_HEADERS, false, HTTPClient.METHOD_POST, body)

	# Check if there were problems:
	if err != OK:
		printerr("HTTPRequest error: " + String(err))
		return

func get_file():
	var command = "get_specific_file"
	var filename = textfield.text.to_upper() + ".tscn"
	var data = {"filename": filename, "local_filepath": level_scene}
	request_queue.push_back({"command": command, "data": data})

func get_json_file():
	var command = "get_json_file"
	var filename = textfield.text.to_upper() + ".json"
	var data = {"filename": filename, "local_filepath": json_folder}
	request_queue.push_back({"command": command, "data": data})

func _on_AnimationPlayer_animation_finished(anim_name):
	$loading_scrreen.visible = false
	$CanvasLayer/dialog_box.visible = true
	$CanvasLayer/dialog_box/ColorRect/VBoxContainer/message.text = "Invalid level code"
