extends Control
var http_request : HTTPRequest = HTTPRequest.new()
const SERVER_URL = "http://192.168.100.247:8080/authentication1.php"
const SERVER_HEADERS = ["Content-Type: application/x-www-form-urlencoded", "Cache-Control: max-age=0"]
var request_queue : Array = []
var is_requesting : bool = false
# This script for directing users into another scene

var previous_scene = "res://online_mode/level_create_Menu/level_create.tscn"
var levels_folder = "res://online_mode/saved_levels/"
onready var level_scene = $HBoxContainer/code

export(NodePath) onready var textfield = get_node(textfield) as LineEdit
export(NodePath) onready var error_popup = get_node(error_popup) as Control

# Called when the node enters the scene tree for the first time.
func _ready():
	add_child(http_request)
	http_request.connect("request_completed", self, "_http_request_completed")
	


func _on_back_pressed():
	Load.load_scene(self,previous_scene)


func _on_join_pressed():
	level_scene = textfield.text.to_upper() + ".tscn"
	var full_path = levels_folder + level_scene
	get_file()
	
	
func _on_continue_pressed():
	error_popup.visible = false

func _process(_delta):
	# Check if we have pending requests in the queue:
	if !request_queue.empty() and !is_requesting:
		var request = request_queue.pop_front()
		_send_request(request)
	
func _http_request_completed(result, response_code, headers, body):
	var download_link
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
		var _response_data = body.get_string_from_utf8()
		print("Response Data:", _response_data)

	if "response" in response and typeof(response["response"]) == TYPE_DICTIONARY:
		var response_dict = response["response"]
		if "file_uploaded" in response_dict:
			download_link = response_dict["file_uploaded"]
			download(download_link, "res://online_mode/saved_levels/"+level_scene)

func _send_request(request : Dictionary):
	var client = HTTPClient.new()
	var data = client.query_string_from_dict({"data" : JSON.print(request['data'])})
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
	var data = {"filename" : filename}
	request_queue.push_back({"command" : command, "data" : data})
	
	
func download(link, path):
	var http = HTTPRequest.new()
	add_child(http)
	http.connect("request_completed", self, "_http_request_completed")
	http.set_download_file(path)
	var request = http.request(link)
	if request != OK:
		push_error("Http request error")

	var file = File.new()
	if file.open(path, File.WRITE) == OK:
		print("File downloaded to:", path)
	
