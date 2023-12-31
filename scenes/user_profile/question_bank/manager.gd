extends Control

var json_file = "user://question_bank/question_bank.json"
var fetched_questions = ""
var question_list = []
var previous_scene = "res://online_mode/createQuiz_professor/createQuiz_professor.tscn"

export (PackedScene) var question_entry
export(NodePath) onready var delete_confirmation = get_node(delete_confirmation) as Control
export(NodePath) onready var question_container = get_node(question_container) as VBoxContainer
export(NodePath) onready var confirmation_yes_button = get_node(confirmation_yes_button) as Button
export(NodePath) onready var question_textEdit = get_node(question_textEdit) as TextEdit
export(NodePath) onready var correct_lineEdit = get_node(correct_lineEdit) as LineEdit
export(NodePath) onready var incorrect1_lineEdit = get_node(incorrect1_lineEdit) as LineEdit
export(NodePath) onready var incorrect2_lineEdit = get_node(incorrect2_lineEdit) as LineEdit
export(NodePath) onready var incorrect3_lineEdit = get_node(incorrect3_lineEdit) as LineEdit
export(NodePath) onready var error_popup = get_node(error_popup) as Control
export(NodePath) onready var add_popup = get_node(add_popup) as Control
export(Resource) var settings_data

func _ready():
	var folderName = "question_bank"
	# Construct the full path to the second folder within the user directory
	var folderPath = "user://" + folderName

	# Create the first folder if it doesn't exist
	var dir = Directory.new()
	if not dir.dir_exists(folderPath):
		if dir.make_dir(folderPath) == OK:
			print("Folder created:", folderPath)
		else:
			printerr("Failed to create Folder 1:", folderPath)
	else:
		print("Folder already exists:", folderPath)

	show_questions()
	
# A function to join items in an array as a string
func join_array(array):
	var separator = ", "
	var joined_string = ""
	
	for i in range(array.size()):
		joined_string += array[i]
		if i < array.size() - 1:
			joined_string += separator
	
	return joined_string
##	

func show_questions():
	#for getting data in a JSON file and putting it in the json_data variable as dictionary
	var file = File.new()
	if file.open(json_file, File.READ) == OK:
		var json_content = file.get_as_text()
		file.close()
		var json_result = JSON.parse(json_content)
		if json_result.error == OK:
			fetched_questions = json_result.result
		else:
			print("JSON parsing error:", json_result.error_string)
	else:
		print("Failed to open JSON file.")
	##
	
	print(fetched_questions)
	
	# To display all fetched questions
	for child in fetched_questions:
		var newQuestion_entry = question_entry.instance()
		newQuestion_entry.find_node("question_content").text = child["question"]
		newQuestion_entry.find_node("answer_content").text = child["answer"]
		newQuestion_entry.find_node("incorrect_content").text = join_array(child["incorrect"])
		newQuestion_entry.delete_confirmation = delete_confirmation
		question_container.add_child(newQuestion_entry)
	##


func _on_yes_pressed():
# for removing questions in View Selected Questions Tab
	for entry in question_container.get_children():
		if entry.find_node("question_content").text == confirmation_yes_button.question:
			entry.queue_free()
	delete_confirmation.visible = false
	##


func _on_no_pressed():
	delete_confirmation.visible = false


func _on_popupAdd_button_pressed():
	if question_textEdit.text == "" || correct_lineEdit.text == "" || incorrect1_lineEdit.text == "" || incorrect2_lineEdit.text == "" || incorrect3_lineEdit.text == "":
		error_popup.visible = true
	else:
		add_question()
		clear_text()


func _on_continue_button_pressed():
	error_popup.visible = false


func _on_add_button_pressed():
	add_popup.visible = true
	question_textEdit.text = ""
	question_textEdit.grab_focus()
	correct_lineEdit.text = ""
	incorrect1_lineEdit.text = ""
	incorrect2_lineEdit.text = ""
	incorrect3_lineEdit.text = ""


func _on_back_button_pressed():
	save_questions()
	var request = HTTPRequest.new()
	request.connect("request_completed", self, "_request_callback")
	add_child(request)
	upload_file(request)
	yield(get_tree().create_timer(1), "timeout")
	Load.load_scene(self, previous_scene)
	
# To save changes in the question_bank.json upon clicking back button
func save_questions():
	for child in question_container.get_children():
		var question_dict = {}
		question_dict["question"] = child.find_node("question_content").text
		question_dict["answer"] = child.find_node("answer_content").text
		question_dict["incorrect"] = child.find_node("incorrect_content").text.split(", ")
		question_list.append(question_dict)
	var json_string = to_json(question_list)
	var file_path = "user://question_bank/question_bank.json"
	var file = File.new()
	
	if file.open(file_path, File.WRITE) == OK:
		file.store_string(json_string)
		file.close()
		print("JSON file saved to: " + file_path)
	else:
		print("Failed to open the file for writing")
##

# To add the newly created question into the list of questions
func add_question():
	var newQuestion_entry = question_entry.instance()
	newQuestion_entry.find_node("question_content").text = str(question_textEdit.text)
	newQuestion_entry.find_node("answer_content").text = str(correct_lineEdit.text)
	var incorrects = [incorrect1_lineEdit.text, incorrect2_lineEdit.text, incorrect3_lineEdit.text]
	newQuestion_entry.find_node("incorrect_content").text = join_array(incorrects)
	newQuestion_entry.delete_confirmation = delete_confirmation
	question_container.add_child(newQuestion_entry)
	add_popup.visible = false
##

# To clear textboxes on add_popup
func clear_text():
	question_textEdit.text = ""
	correct_lineEdit.text = ""
	incorrect1_lineEdit.text = ""
	incorrect2_lineEdit.text = ""
	incorrect3_lineEdit.text = ""
##


func _on_close_button_pressed():
	add_popup.visible = false

func upload_file(request: HTTPRequest) -> void:
	var file_name = settings_data.email + ".json"
	var email = settings_data.email
	
	var file = File.new()
	file.open(json_file, File.READ)
	var file_data = file.get_buffer(file.get_len())  # Read the file as binary data
	file.close()
	
	var body = PoolByteArray()
	body.append_array("\r\n--BodyBoundaryHere\r\n".to_utf8())
	body.append_array(("Content-Disposition: form-data; name=\"email\"\r\n\r\n%s\r\n" % email).to_utf8())

	body.append_array("\r\n--BodyBoundaryHere\r\n".to_utf8())
	body.append_array(("Content-Disposition: form-data; name=\"file\"; filename=\"%s\"\r\n" % file_name).to_utf8())
	body.append_array("Content-Type: application/octet-stream\r\n\r\n".to_utf8())
	body.append_array(file_data)
	body.append_array("\r\n--BodyBoundaryHere--\r\n".to_utf8())

	var headers = [
		"Content-Type: multipart/form-data; boundary=BodyBoundaryHere"
	]
	# Replace the following URL with the actual URL of your PHP server script
	var server_url = "https://nwork.slarenasitsolutions.com/upload_question_bank.php"  # Replace with your server's URL

	request.connect("request_completed", self, "http_request_completed")
	request.request_raw(server_url, headers, true, HTTPClient.METHOD_POST, body)


func http_request_completed(result, response_code, headers, body):
	if result != OK:
		pass
	else:
		pass
