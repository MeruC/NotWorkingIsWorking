extends CanvasLayer
var http_request : HTTPRequest = HTTPRequest.new()
const SERVER_URL = "https://nwork.slarenasitsolutions.com/authentication.php"
const SERVER_HEADERS = ["Content-Type: application/x-www-form-urlencoded", "Cache-Control: max-age=0"]
var request_queue : Array = []
var is_requesting : bool = false
onready var grid_container = $ScrollContainer/GridContainer
var headers = []  # Initialize headers as an empty array
export (Resource) var settings_data
var response
var currentLevelName: String = ""
var responseData = []
var itsave = false

func _ready():
	add_child(http_request)
	http_request.connect("request_completed", self, "_http_request_completed")
	
func _process(_delta):
	# Check if we have pending requests in the queue:
	if !request_queue.empty() and !is_requesting:
		var request = request_queue.pop_front()
		_send_request(request)
		
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
		
func _http_request_completed(result, response_code, headers, body):
	is_requesting = false
	
	if result != HTTPRequest.RESULT_SUCCESS:
		printerr("Error with connection: " + str(result))
		return
	var response_body = body.get_string_from_utf8()
		
	if response_body.empty():
		$export.disabled = true
		$ScrollContainer/GridContainer.visible = false
		$Label.text = "no one answered yet."
		return
		
	response = parse_json(response_body)
	if response is Array:
		if response.size() > 0:
			var data = response  # The response is an array of dictionaries
			responseData = response 
			headers = data[0].keys()
			$ScrollContainer/GridContainer.visible = true
			$Label.text = ""
			display_table(data)
			$export.disabled = false

func display_table(data):
	# Define your headers manually
	headers = ["username", "scores"]
	# Clear the existing grid contents
	clear_grid()

	var font_resource = preload("res://resources/font/login_signup_font.tres")
	var font_color = Color(0, 0, 0, 1)
	for j in range(headers.size()):
		var header_label = Label.new()
		header_label.text = headers[j]
		header_label.rect_min_size = Vector2(600, 30)  # Set the size here
		header_label.add_font_override("font", font_resource)
		header_label.add_color_override("font_color", font_color)
		grid_container.add_child(header_label)
		header_label.align = Label.ALIGN_CENTER  # Center-align text

	# Create and add data cells to subsequent rows
	for i in range(data.size()):
		var row = data[i]
		for j in range(headers.size()):
			if headers[j] == "file_name":  # Check if the header is "email"
				var cell_button = Button.new()  # Create a button for email addresses
				cell_button.text = str(row[headers[j]])  # Set the button text to the email address
			else:
				var cell_label = Label.new()  # Create a label for other data
				cell_label.text = str(row[headers[j]])
				cell_label.add_font_override("font", font_resource)
				cell_label.add_color_override("font_color", font_color)
				cell_label.rect_min_size = Vector2(200, 90)  # Set the size here
				grid_container.add_child(cell_label)
				cell_label.align = Label.ALIGN_CENTER  # Center-align text

func clear_grid():
	# Remove all child nodes from the grid_container
	while grid_container.get_child_count() > 0:
		var child = grid_container.get_child(0)
		grid_container.remove_child(child)
		child.queue_free()

func get_levelresult(value):
	$"../exit".disabled = true
	var command = "get_levelresult"
	var levelname = value.replace(".tscn", "")
	var data = {"level_name": levelname}
	request_queue.push_back({"command": command, "data": data})
	$".".visible = true
	
	currentLevelName = levelname
	


func _on_back_pressed():
	$".".visible = false
	$"../exit".disabled = false


func _on_export_pressed():
	$"../file_dialog_title".visible = true
	$"../file_dialog".visible = true
	$"../file_dialog/FileDialog".popup()
	$"../file_dialog/FileDialog".mode = FileDialog.MODE_SAVE_FILE  # Corrected line
	$"../file_dialog/FileDialog".filters = ["*.csv"]
	# Connect the "file_selected" signal of the FileDialog to this function
	$"../file_dialog/FileDialog".connect("file_selected", self, "_on_SaveFileDialog_file_selected")
# Connect the "file_selected" signal of the FileDialog to this function
func _on_SaveFileDialog_file_selected(path):
	if path.empty():
		return  # User canceled the dialog
	if not path.ends_with(".csv"):
	   path += ".csv"
	
	# Perform the save operation here using the provided data
	export_csv_data(responseData, path)

# Modify your export_csv_data function to accept the path as an argument
func export_csv_data(data, path):
	var csv_data = "Name, score\n"  # CSV header row
	for item in data:
		if item is Dictionary:
			var name = item.get("username", "")
			var scores = item.get("scores", 0)
			csv_data += '"' + name + '",' + str(scores) + ',"' + '"\n'


	# You can use responseData here to access the response data
	var file = File.new()
	if file.open(path, File.WRITE) == OK:
		file.store_string(csv_data)
		file.close()
		itsave = true
	else:
		print("Error saving CSV data")


func _on_FileDialog_popup_hide():
	if itsave == true:
		$"../message_prompt".visible = true
		$"../message_prompt/message".text = "The file was successfully saved"
		$"../file_dialog_title".visible = false
		$"../file_dialog".visible = false
		itsave = false
	else:
		$"../message_prompt".visible = true
		$"../message_prompt/message".text = "The operation was cancelled"
		$"../file_dialog_title".visible = false
		$"../file_dialog".visible = false
