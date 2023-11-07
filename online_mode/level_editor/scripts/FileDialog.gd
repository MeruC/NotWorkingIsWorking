extends FileDialog

onready var level = get_node("/root/editor/level")
onready var ui = get_node("/root/editor/UI")
onready var play = get_node("/root/editor/UI/editor/file/menu/play")
onready var main = get_node("/root/editor")

var last_pos
onready var editor_camera = $"../../../../Editor_Camera"
export(Resource) onready var settings_data
var selected_file = ""
var game_code
func refresh():
	self._draw()
	
func _draw():
	set_current_dir("user://saved_levels/")

onready var popup : FileDialog = self
onready var file_dialog_top_bar = $"../../FileDialogTopBar"
onready var file_dialog = $".."
onready var file_dialog_title = $"../../FileDialogTopBar/FileDialogTitle"

func _ready():
	last_pos = Vector3(0, 0, 0)
	#$"../../file/upload".disabled = true
	SignalManager.connect( "confirm", self, "_on_confirm_pressed" )

func _on_confirm_pressed(action):
	match(action):
		"new_level":
			get_tree().change_scene_to(load("res://online_mode/level_create_Menu/level_create.tscn"))
		
func _on_Save_pressed():
	#last_pos = editor_camera.translation
	#editor_camera.translation = Vector3(100,0,100)
	Global.on_save_load = true
	file_dialog_title.text = "SAVE LEVEL"
	file_dialog.set_visible(true)
	file_dialog_top_bar.set_visible(true)
	play.set_visible(false)
	ui.set_visible(false)
	Global.can_place = false
	popup.mode = 4
	popup.popup()
	pass # Replace with function body.

func _on_Load_pressed():
	#last_pos = editor_camera.translation
	#editor_camera.translation = Vector3(100,0,100)
	Global.on_save_load = true
	file_dialog_title.text = "LOAD LEVEL"
	file_dialog.set_visible(true)
	file_dialog_top_bar.set_visible(true)
	ui.set_visible(false)
	Global.can_place = false
	popup.mode = 0
	popup.popup()
	pass # Replace with function body.


func _on_FileDialog_popup_hide():
	#last_pos = editor_camera.translation
	#editor_camera.translation = last_pos
	Global.on_save_load = false
	Global.can_place = true
	play.set_visible(true)
	ui.set_visible(true)
	file_dialog.set_visible(false)
	file_dialog_top_bar.set_visible(false)
	pass # Replace with function body.
	

func _on_FileDialog_confirmed():
	if popup.window_title == "Save a File":
		save_level()
	else:
		load_level()
	pass # Replace with function body.

func save_level():
	var toSave : PackedScene = PackedScene.new()
	toSave.pack(level)
	var result = ResourceSaver.save(popup.current_path,toSave)
	level.saved = true
	
	
func load_level():
	var toLoad : PackedScene = PackedScene.new()
	toLoad = ResourceLoader.load(popup.current_path)
	var this_level = toLoad.instance()
	main.remove_child(level)
	level.queue_free()
	main.add_child(this_level)
	level = this_level
	
func new_level():
	if level.saved:
		get_tree().change_scene_to(load("res://online_mode/level_create_Menu/level_create.tscn"))
	else:
		ConfirmDialog.mode = "Confirm Dialog"
		ConfirmDialog._ready()
		ConfirmDialog.set_visible(true)
		ConfirmDialog.confirm_animation.play("intro")
		ConfirmDialog.label.text = "Level hasn't been\nsaved yet, continue?"
		ConfirmDialog.action = "new_level"

func _on_Save_mouse_entered():
	Global.can_place = false
	

func _on_Save_mouse_exited():
	Global.can_place = true


func _on_Load_mouse_entered():
	Global.can_place = false


func _on_Load_mouse_exited():
	Global.can_place = true


func _on_New_pressed():
	new_level()


func _on_Orphan_pressed():
	 print_stray_nodes()

func _on_upload_pressed():
	var request = HTTPRequest.new()
	request.connect("request_completed", self, "_request_callback")
	add_child(request)
	upload_file(request, selected_file)
	


func _on_FileDialog_file_selected(path):
	var filename = path.replace("user://saved_levels/", "")
	selected_file = filename
	#$"../../file/upload".disabled = false

func generate_unique_code(length: int = 8) -> String:
	# To generate a unique level code
	var isNotUnique = true
	var charset = "ABCDEFGHIJKLMNPQRSTUVWXYZ0123456789"
	var code = ""
	var file_name
	
	for i in range(length):
		var random_index = randi() % charset.length()
		code += charset.substr(random_index, 1)
		file_name = code + ".tscn"
	return code
	##
	
func generate_qr(game_code):
	var QRcode: qr_code = qr_code.new()
	QRcode.error_correct_level = QrCode.ERROR_CORRECT_LEVEL.MEDIUM
	var texture: ImageTexture = QRcode.get_texture(game_code)
	$"../../prompt_QR/qr".texture = texture
	
func upload_file(request: HTTPRequest, game_code: String) -> void:
	var original_file_name = game_code
	var creator_name = settings_data.email
	var file_path = "user://saved_levels/" + original_file_name
	var file = File.new()
	file.open(file_path, File.READ)
	var file_data = file.get_buffer(file.get_len())
	file.close()

	var unique_file_name = generate_unique_code()  # Generate a unique name for the file
	var level_name = unique_file_name+".tscn"
	var body = PoolByteArray()
	body.append_array("\r\n--BodyBoundaryHere\r\n".to_utf8())
	body.append_array(("Content-Disposition: form-data; name=\"creator\"\r\n\r\n%s\r\n" % creator_name).to_utf8())

	body.append_array("\r\n--BodyBoundaryHere\r\n".to_utf8())
	body.append_array(("Content-Disposition: form-data; name=\"file\"; filename=\"%s\"\r\n" % level_name).to_utf8())
	body.append_array("Content-Type: application/octet-stream\r\n\r\n".to_utf8())
	body.append_array(file_data)
	body.append_array("\r\n--BodyBoundaryHere--\r\n".to_utf8())

	var headers = [
		"Content-Type: multipart/form-data; boundary=BodyBoundaryHere"
	]

	# Replace the following URL with the actual URL of your PHP server script
	var server_url = "https://nwork.slarenasitsolutions.com/upload_3d.php"  # Replace with your server's URL
	request.request_raw(server_url, headers, true, HTTPClient.METHOD_POST, body)
	generate_qr(unique_file_name)
	$"../../prompt_QR/code".text = unique_file_name.replace(".tscn", "")
	$"../../prompt_QR".visible = true
	# You can also save the unique_file_name and original_file_name for reference if needed

func _request_callback(result, response_code, headers, body) -> void:
	if response_code == HTTPClient.RESPONSE_OK:
		var response = str2var(body.get_string_from_utf8())
		print(response)
	elif response_code == HTTPClient.STATUS_DISCONNECTED:
		print("not connected to server")



func _on_FileDialog_mouse_entered():
	Global.can_place = false


func _on_FileDialog_mouse_exited():
	Global.can_place = true
