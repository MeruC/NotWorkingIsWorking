extends Spatial

var player
onready var inventory = $inventory
onready var mobile_controls = $mobile_controls
onready var tasks_ui = $tasks_ui
onready var task_manager = $tasks_ui/task_manager
onready var tasks_container = $tasks_ui/task_manager/ScrollContainer/tasks_vbox
onready var level_scene = self
onready var main_scene = get_tree().get_root().get_child(get_tree().get_root().get_child_count()-1)
onready var submit_button

var computer_list = []
var tasks_list = []
var tasks_cbs = []


var joystick
export (Resource) var setting_data
var onMenu = false
#var lesson = preload("res://offline_levels/level1/level1_discussion/level1_discussion.tscn")


var nodes : Array = []
func get_all_monitor(node) -> Array:
	for N in node.get_children():
		#print(N)
		if "object_monitor" in N.name:
			nodes.append(N)
			N.connect("configuration_saved", self, "_on_configuration_saved")
	return nodes
	
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
	submit_button = task_manager.get_child(1)
	get_all_tasks()
	get_all_computer()
	check_ip("0.0.0.0", "0.0.0.0")
	
	LevelGlobal.object_hold = null
	if get_parent().name != "editor":
		inventory.set_visible(true)
		mobile_controls.set_visible(true)
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
	SignalManager.connect( "router_open", self, "_on_router_open" )
	SignalManager.connect( "router_close", self, "_on_router_close" )

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
	inventory.ui_container.set_visible(false)
	mobile_controls.buttons.set_visible(false)
	mobile_controls.cable_ui.set_visible(true)
	tasks_ui.get_child(0).pressed = false

func _on_cable_done():
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
	enable_submit()

func check_task1():
	if find_taskName(tasks_list, "task1") != -1:
		var device_list = []
		for node in main_scene.get_children():
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
	if find_taskName(tasks_list, "task2") != -1:
		var splitted_ip = computer_list[0].ipv4_address.split(".")
		if splitted_ip.size() == 4:
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
	if find_taskName(tasks_list, "task3") != -1:
		for computer in computer_list:
			if computer.fe0 != null and computer.ipv4_address != null and "Router" in computer.fe0.name:
				if computer.default_gateway == computer.fe0.ge0_ip or computer.default_gateway == computer.fe0.ge1_ip or computer.default_gateway == computer.fe0.ge2_ip:
					tasks_cbs[find_taskName(tasks_list, "task3")].pressed = true
				else:
					tasks_cbs[find_taskName(tasks_list, "task3")].pressed = false
					return
			else:
				tasks_cbs[find_taskName(tasks_list, "task3")].pressed = false
				return
		tasks_cbs[find_taskName(tasks_list, "task3")].pressed = true
		
func check_task4():
	if find_taskName(tasks_list, "task4") != -1:
		var router
		var splitted_ge0ip
		var splitted_ge1ip
		var splitted_ge2ip
		for device in main_scene.get_children():
			if "Router" in device.name:
				router = device
		if "Router" in router.name:
			splitted_ge0ip = router.ge0_ip.split(".")
			splitted_ge1ip = router.ge1_ip.split(".")
			splitted_ge2ip = router.ge2_ip.split(".")
			if (int(splitted_ge0ip[0]) >= 192 and int(splitted_ge0ip[0]) <= 223) and (int(splitted_ge1ip[0]) >= 192 and int(splitted_ge1ip[0]) <= 223) and (int(splitted_ge2ip[0]) >= 192 and int(splitted_ge2ip[0]) <= 223):
				tasks_cbs[find_taskName(tasks_list, "task4")].pressed = true
				return
			else:
				tasks_cbs[find_taskName(tasks_list, "task4")].pressed = false
				return
			
func check_task5():
	if find_taskName(tasks_list, "task5") != -1:
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
