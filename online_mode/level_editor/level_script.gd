extends Spatial

###ENABLED TASK
export(bool) var setConn = true
export(bool) var testConn = true
export(bool) var confIP = false
export(bool) var confPC = false
export(bool) var confRouter = false
export(String) var confIPClass = "Class A"
export(String) var confRouterClass = "Class A"
var all_task = []

export(String) var level_name = "MyLevel"
export(String) var level_desc = "Set a description for your level!"
export(String) var timerChoice = "5:00"
var initialTimerDuration: int = 300
var player

onready var inventory = $inventory
onready var mobile_controls = $mobile_controls
onready var tasks_ui = $tasks_ui
onready var task_manager = $tasks_ui/task_manager
onready var tasks_container = $tasks_ui/task_manager/ScrollContainer/tasks_vbox
onready var popups = $popups
export (NodePath) onready var submit_button = find_node("submit_button")
export (NodePath) onready var instruction = find_node("content")
export (NodePath) onready var prompt = find_node("submit_button_prompt")
export (NodePath) onready var timer = find_node("Timer")
export (NodePath) onready var time = find_node("time")
var verified = false
var saved = false
var computer_list = []
var tasks_list = []
var tasks_cbs = []
var device_list = []

var http_request : HTTPRequest = HTTPRequest.new()
const SERVER_URL = "https://nwork.slarenasitsolutions.com/authentication.php"
const SERVER_HEADERS = ["Content-Type: application/x-www-form-urlencoded", "Cache-Control: max-age=0"]
var request_queue : Array = []
var is_requesting : bool = false
var current_time = 0

var joystick
export (Resource) var setting_data
var onMenu = false
#var lesson = preload("res://offline_levels/level1/level1_discussion/level1_discussion.tscn")


func _enable_task():
	for task in tasks_container.get_children():
			all_task.append(task)
	all_task[0].visible = setConn
	all_task[10].visible = testConn
	if confIP:
		match(confIPClass):
			"Class A":
				all_task[1].visible = true
			"Class B":
				all_task[2].visible = true
			"Class C":
				all_task[3].visible = true
	if confRouter:
		match(confRouterClass):
			"Class A":
				all_task[4].visible = true
			"Class B":
				all_task[6].visible = true
			"Class C":
				all_task[8].visible = true
	if confPC:
		match(confIPClass):
			"Class A":
				all_task[5].visible = true
			"Class B":
				all_task[7].visible = true
			"Class C":
				all_task[9].visible = true
	
var nodes : Array = []
func get_all_monitor(node) -> Array:
	for N in node.get_children():
		#print(N)
		if "object_monitor" in N.name:
			nodes.append(N)
			N.connect("configuration_saved", self, "_on_configuration_saved")
	return nodes
	
func reset_level():
	_enable_task()
	get_all_tasks()
	
	for cb in tasks_cbs:
		cb.pressed = false
	
	for N in self.get_children():
		if N.has_method("resetLevel"):
			N.resetLevel()
	SaveManager.load_game()
	
func check_ip(ip, subnetmask):
	for N in nodes:
		if (N.ipv4_address == ip) and (N.subnet_mask == subnetmask):
			print("pass")
			
func _on_configuration_saved():
	check_progress()
	
func get_all_computer():
	for node in self.get_children():
		if "object_monitor" in node.name:
			computer_list.append(node)
func _ready():
	timer.start()
	_enable_task()
	instruction.text = ""+level_desc
	add_child(http_request)
	Global.playerCanMove = true
	#upload_btn.disabled = true
	submit_button = task_manager.get_child(1)
	get_all_tasks()
	get_all_computer()
	check_ip("0.0.0.0", "0.0.0.0")
	
	LevelGlobal.object_hold = null
	if get_parent().name != "editor":
		popups.set_visible(true)
		inventory.set_visible(true)
		mobile_controls.set_visible(true)
		tasks_ui.set_visible(true)
		if setting_data.gender == "male":
			player = preload("res://global/player/player.tscn")
			add_child(player.instance())
			Global.playerCamera = get_node("Player/Camera/Camera")
			Global.playerCamera.current = true
			Global.playerCameraTop = get_node("Player/CameraTop")
			Global.player = get_node("Player")
			Global.player.current_level = self
		elif setting_data.gender == "female":
			print("Hello")
			player = preload("res://global/player_girl/player-girl.tscn")
			add_child(player.instance())
			Global.playerCamera = get_node("Player/Camera/Camera")
			Global.playerCamera.current = true
			Global.playerCameraTop = get_node("Player/CameraTop")
			Global.player = get_node("Player")
			Global.player.current_level = self
		
		
	SignalManager.connect( "pc_opened", self, "_on_pc_opened" )
	SignalManager.connect( "pc_closed", self, "_on_pc_closed" )
	SignalManager.connect( "cable_used", self, "_on_cable_used" )
	SignalManager.connect( "cable_done", self, "_on_cable_done" )
	SignalManager.connect( "cable_ui", self, "_on_cable_ui" )
	SignalManager.connect( "cable_back", self, "_on_cable_back" )
	SignalManager.connect( "router_open", self, "_on_router_open" )
	SignalManager.connect( "router_close", self, "_on_router_close" )
	SignalManager.connect( "craft", self, "_craft")
	SignalManager.connect( "craft_end", self, "_craft_end")

func _craft():
	mobile_controls.set_visible(false)
	Global.playerCanMove = false
	
func _craft_end():
	mobile_controls.set_visible(true)
	Global.playerCanMove = true

func _on_pc_opened():
	#player = main.get_node("Player")
	inventory.set_visible(false)
	mobile_controls.set_visible(false)
	onMenu = true
	Global.playerCanMove = false
	tasks_ui.get_child(0).pressed = false
	
func _on_pc_closed():
	#player = main.get_node("Player")
	if (onMenu):
		yield(CameraTransition.transition_camera3D(get_viewport().get_camera(), Global.playerCamera , 1), "completed")
		Global.player.get_node("Pivot").set_visible(true)
		onMenu = false
		Global.playerCanMove = true
		Global.playerInteractLbl.set_visible(true)
		inventory.set_visible(true)
		mobile_controls.set_visible(true)
		tasks_ui.get_child(0).pressed = false
		
		
func _on_router_open():
	#player = main.get_node("Player")
	inventory.set_visible(false)
	mobile_controls.set_visible(false)
	onMenu = true
	Global.playerCanMove = false
	tasks_ui.get_child(0).pressed = false
	
func _on_router_close():
	#player = main.get_node("Player")
	if (onMenu):
		yield(CameraTransition.transition_camera3D(get_viewport().get_camera(), Global.playerCamera , 1), "completed")
		Global.player.get_node("Pivot").set_visible(true)
		onMenu = false
		Global.playerCanMove = true
		Global.playerInteractLbl.set_visible(true)
		inventory.set_visible(true)
		mobile_controls.set_visible(true)
		tasks_ui.get_child(0).pressed = false
		
func _on_cable_used():
	if (get_parent().name == "editor"):
		get_parent().other_ui.set_visible(false)
	inventory.ui_container.set_visible(false)
	mobile_controls.buttons.set_visible(false)
	yield(get_tree().create_timer(1), "timeout")
	mobile_controls.cable_ui.set_visible(true)
	tasks_ui.get_child(0).pressed = false

func _on_cable_done():
	if (get_parent().name == "editor"):
		get_parent().other_ui.set_visible(true)
	inventory.ui_container.set_visible(true)
	mobile_controls.buttons.set_visible(true)
	tasks_ui.get_child(0).pressed = false
	#mobile_controls.cable_ui.set_visible(false)
	
func _on_cable_ui():
	if (get_parent().name == "editor"):
		get_parent().other_ui.set_visible(false)
	inventory.ui_container.set_visible(false)
	mobile_controls.buttons.set_visible(false)
	yield(get_tree().create_timer(1), "timeout")
	mobile_controls.cable_ui2.set_visible(true)
	tasks_ui.get_child(0).pressed = false

func _on_cable_back():
	if (get_parent().name == "editor"):
		get_parent().other_ui.set_visible(true)
	inventory.ui_container.set_visible(true)
	mobile_controls.buttons.set_visible(true)
	tasks_ui.get_child(0).pressed = false
	#mobile_controls.cable_ui.set_visible(false)
	
func get_all_tasks():
	for task in tasks_container.get_children():
		if task.visible == true:
			tasks_list.append(task.get_name())
			tasks_cbs.append(task.get_child(0))
			
func enable_submit():
	for cb in tasks_cbs:
		if cb.pressed == true:
			pass
		else:
			return
	submit_button.visible = true
			
func check_progress():
	check_task1()
	check_task2()
	check_task3()
	check_task4()
	check_task5()
	check_task6()
	check_task7()
	check_task8()
	check_task9()
	check_task10()
	check_task11()
	enable_submit()

func check_task1():
	if find_taskName(tasks_list, "task1") != -1:
		var device_list = []
		for node in self.get_children():
			if "object_monitor" in node.name or "Router" in node.name:
				device_list.append(node)
		for device in device_list:
			if "object_monitor" in device.name and device.fe0 != null:
				pass
			elif "Router" in device.name and device.ge0 != null and device.ge1 != null and device.ge2 != null:
				pass
			else:
				tasks_cbs[find_taskName(tasks_list, "task1")].pressed = false
				return
		tasks_cbs[find_taskName(tasks_list, "task1")].pressed = true

func check_task2():
	get_all_computer()
	if find_taskName(tasks_list, "task2") != -1:
		var splitted_ip = computer_list[0].ipv4_address.split(".")
		if splitted_ip.size() == 4 and (int(splitted_ip[0]) > 0 and int(splitted_ip[0]) < 127):
			var base_ip = splitted_ip[0] + "." + splitted_ip [1] + "." + splitted_ip[2]
			for computer in computer_list:
				if starts_with(computer.ipv4_address, base_ip):
					pass
				else:
					tasks_cbs[find_taskName(tasks_list, "task2")].pressed = false
					return
			tasks_cbs[find_taskName(tasks_list, "task2")].pressed = true
			return
			
func check_task3():
	get_all_computer()
	if find_taskName(tasks_list, "task3") != -1:
		var splitted_ip = computer_list[0].ipv4_address.split(".")
		if splitted_ip.size() == 4 and (int(splitted_ip[0]) > 127 and int(splitted_ip[0]) < 192):
			var base_ip = splitted_ip[0] + "." + splitted_ip [1] + "." + splitted_ip[2]
			for computer in computer_list:
				if starts_with(computer.ipv4_address, base_ip):
					pass
				else:
					tasks_cbs[find_taskName(tasks_list, "task3")].pressed = false
					return
			tasks_cbs[find_taskName(tasks_list, "task3")].pressed = true
			return

func check_task4():
	get_all_computer()
	if find_taskName(tasks_list, "task4") != -1:
		var splitted_ip = computer_list[0].ipv4_address.split(".")
		if splitted_ip.size() == 4 and (int(splitted_ip[0]) > 191 and int(splitted_ip[0]) < 224):
			var base_ip = splitted_ip[0] + "." + splitted_ip [1] + "." + splitted_ip[2]
			for computer in computer_list:
				if starts_with(computer.ipv4_address, base_ip):
					pass
				else:
					tasks_cbs[find_taskName(tasks_list, "task4")].pressed = false
					return
			tasks_cbs[find_taskName(tasks_list, "task4")].pressed = true
			return

func check_task5():
	if find_taskName(tasks_list, "task5") != -1:
		var router
		var splitted_ge0ip
		var splitted_ge1ip
		var splitted_ge2ip
		for device in self.get_children():
			if "Router" in device.name:
				router = device
		if router != null:
			if "Router" in router.name:
				splitted_ge0ip = router.ge0_ip.split(".")
				splitted_ge1ip = router.ge1_ip.split(".")
				splitted_ge2ip = router.ge2_ip.split(".")
				if (int(splitted_ge0ip[0]) >= 1 and int(splitted_ge0ip[0]) <= 126) and (int(splitted_ge1ip[0]) >= 1 and int(splitted_ge1ip[0]) <= 126) and (int(splitted_ge2ip[0]) >= 1 and int(splitted_ge2ip[0]) <= 126):
					tasks_cbs[find_taskName(tasks_list, "task5")].pressed = true
					return
				else:
					tasks_cbs[find_taskName(tasks_list, "task5")].pressed = false
					return

func check_task6():
	if find_taskName(tasks_list, "task6") != -1:
		for computer in computer_list:
			var splitted_ip = computer.ipv4_address.split(".")
			if computer.fe0 != null and computer.ipv4_address != null and "Router" in computer.fe0.name:
				if computer.default_gateway == computer.fe0.ge0_ip or computer.default_gateway == computer.fe0.ge1_ip or computer.default_gateway == computer.fe0.ge2_ip and (int(splitted_ip[0]) >= 1 and int(splitted_ip[0]) <= 126):
					#tasks_cbs[find_taskName(tasks_list, "task3")].pressed = true
					pass
				else:
					tasks_cbs[find_taskName(tasks_list, "task6")].pressed = false
					return
			else:
				tasks_cbs[find_taskName(tasks_list, "task6")].pressed = false
				return
		tasks_cbs[find_taskName(tasks_list, "task6")].pressed = true

func check_task7():
	if find_taskName(tasks_list, "task7") != -1:
		var router
		var splitted_ge0ip
		var splitted_ge1ip
		var splitted_ge2ip
		for device in self.get_children():
			if "Router" in device.name:
				router = device
		if router != null:
			if "Router" in router.name:
				splitted_ge0ip = router.ge0_ip.split(".")
				splitted_ge1ip = router.ge1_ip.split(".")
				splitted_ge2ip = router.ge2_ip.split(".")
				if (int(splitted_ge0ip[0]) >= 128 and int(splitted_ge0ip[0]) <= 191) and (int(splitted_ge1ip[0]) >= 128 and int(splitted_ge1ip[0]) <= 191) and (int(splitted_ge2ip[0]) >= 128 and int(splitted_ge2ip[0]) <= 191):
					tasks_cbs[find_taskName(tasks_list, "task7")].pressed = true
					return
				else:
					tasks_cbs[find_taskName(tasks_list, "task7")].pressed = false
					return

func check_task8():
	if find_taskName(tasks_list, "task8") != -1:
		for computer in computer_list:
			var splitted_ip = computer.ipv4_address.split(".")
			if computer.fe0 != null and computer.ipv4_address != null and "Router" in computer.fe0.name:
				if computer.default_gateway == computer.fe0.ge0_ip or computer.default_gateway == computer.fe0.ge1_ip or computer.default_gateway == computer.fe0.ge2_ip and (int(splitted_ip[0]) >= 128 and int(splitted_ip[0]) <= 191):
					#tasks_cbs[find_taskName(tasks_list, "task3")].pressed = true
					pass
				else:
					tasks_cbs[find_taskName(tasks_list, "task8")].pressed = false
					return
			else:
				tasks_cbs[find_taskName(tasks_list, "task8")].pressed = false
				return
		tasks_cbs[find_taskName(tasks_list, "task8")].pressed = true

func check_task9():
	if find_taskName(tasks_list, "task9") != -1:
		var router
		var splitted_ge0ip
		var splitted_ge1ip
		var splitted_ge2ip
		for device in self.get_children():
			if "Router" in device.name:
				router = device
		if router != null:
			if "Router" in router.name:
				splitted_ge0ip = router.ge0_ip.split(".")
				splitted_ge1ip = router.ge1_ip.split(".")
				splitted_ge2ip = router.ge2_ip.split(".")
				if (int(splitted_ge0ip[0]) >= 192 and int(splitted_ge0ip[0]) <= 223) and (int(splitted_ge1ip[0]) >= 192 and int(splitted_ge1ip[0]) <= 223) and (int(splitted_ge2ip[0]) >= 192 and int(splitted_ge2ip[0]) <= 223):
					tasks_cbs[find_taskName(tasks_list, "task9")].pressed = true
					return
				else:
					tasks_cbs[find_taskName(tasks_list, "task9")].pressed = false
					return

func check_task10():
	if find_taskName(tasks_list, "task10") != -1:
		for computer in computer_list:
			var splitted_ip = computer.ipv4_address.split(".")
			if computer.fe0 != null and computer.ipv4_address != null and "Router" in computer.fe0.name:
				if computer.fe0.ge0_ip != "" and computer.fe0.ge1_ip != "" and computer.fe0.ge2_ip != "" and computer.default_gateway == computer.fe0.ge0_ip or computer.default_gateway == computer.fe0.ge1_ip or computer.default_gateway == computer.fe0.ge2_ip and (int(splitted_ip[0]) >= 192 and int(splitted_ip[0]) <= 223):
					#tasks_cbs[find_taskName(tasks_list, "task3")].pressed = true
					pass
				else:
					tasks_cbs[find_taskName(tasks_list, "task10")].pressed = false
					return
			else:
				tasks_cbs[find_taskName(tasks_list, "task10")].pressed = false
				return
		tasks_cbs[find_taskName(tasks_list, "task10")].pressed = true
			
func check_task11():
	if find_taskName(tasks_list, "task11") != -1:
		var device_list = []
		for node in self.get_children():
			if "object_monitor" in node.name or "Router" in node.name:
				device_list.append(node)
				
	
func find_taskName(tasks_list, task_name):
	for i in range(tasks_list.size()):
		if tasks_list[i] == task_name:
			return i
	return -1

func starts_with(text, prefix):
	if text.length() < prefix.length():
		return false
	return text.substr(0, prefix.length()) == prefix

#online
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
	print(response)
	if result == HTTPRequest.RESULT_SUCCESS:
		var _response_data = body.get_string_from_utf8()
		print("Response Data:", _response_data)
	# Handle the submission process (e.g., show a success message)
	
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

func _on_yes_pressed():
	addScore()


func _on_submit_button_pressed():
	prompt.visible = true
	tasks_ui.visible = false
	
func addScore():
	var username = setting_data.player_name
	var section = setting_data.section
	var scores = "Completed"
	var table_name = setting_data.online_level
	var data = {
		"command": "upload_score",
		"username": username,
		"section": section,
		"scores": scores,
		"table_name": table_name
	}
	var command = "upload_score"
	request_queue.push_back({"command": command, "data": data})
	_send_request({"command": command, "data": data})
	yield(get_tree().create_timer(1), "timeout")
	Load.load_scene(self, "res://scenes/main_screen/main_screen.tscn")


func _on_no_pressed():
	prompt.visible = false

func _on_set_time():
	match timerChoice:
		"5:00":
			set_timer_duration(300)
		"10:00":
			set_timer_duration(600)
		"15:00":
			set_timer_duration(900)
		"30:00":
			set_timer_duration(1800)
		"60:00":
			set_timer_duration(3600)

func set_timer_duration(duration):
	initialTimerDuration = duration
	timer.set_wait_time(duration)
	current_time = 0.0
	update_time_label()

func _process(delta):
	current_time += delta
	var remaining_time = initialTimerDuration - current_time

	if remaining_time <= 0:
		remaining_time = 0
		timer.stop()
	timer.set_wait_time(remaining_time)
	update_time_label()

func update_time_label():
	# Assuming you have a label node named 'time' in your scene
	time.text = format_time(timer.get_time_left())

func format_time(seconds):
	var minutes = int(seconds / 60)
	var remainingSeconds = int(seconds) % 60
	return str(minutes).pad_zeros(2) + ":" + str(remainingSeconds).pad_zeros(2)


func _on_Timer_timeout():
	var username = setting_data.player_name
	var section = setting_data.section
	var scores = "Incomplete"
	var table_name = setting_data.online_level
	var data = {
		"command": "upload_score",
		"username": username,
		"section": section,
		"scores": scores,
		"table_name": table_name
	}
	var command = "upload_score"
	request_queue.push_back({"command": command, "data": data})
	_send_request({"command": command, "data": data})
	yield(get_tree().create_timer(1), "timeout")
	Load.load_scene(self, "res://scenes/main_screen/main_screen.tscn")


func _on_Button_pressed():
	timer.start()
