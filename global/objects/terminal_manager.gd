extends Control

onready var computer = $"../../../.."
onready var commands_container = $"../main_panel/ScrollContainer/commands_container"
onready var level_scene = get_tree().get_root().get_child(get_tree().get_root().get_child_count()-1)
var configurable_router
export(PackedScene) var global_cli
export(PackedScene) var interface_cli
export(PackedScene) var line_cli
export(PackedScene) var priveleged_cli
export(PackedScene) var routing_cli
export(PackedScene) var default_cli
export(PackedScene) var user_cli
export(PackedScene) var password_line
export(String) var to_be_configured 
export(int) var position = 0
var correct_pass

func _on_terminal_app_visibility_changed():
	if computer.console_port_connection != null:
		for child in level_scene.get_children():
			if child is StaticBody and has_property(child, "device_name") and child.device_name == computer.console_port_connection:
				configurable_router = child
				if configurable_router.priveleged_password != null:
					correct_pass = false
				else:
					correct_pass = true
	
	position = 0
	var first_child = commands_container.get_child(0)
	
	for i in range(1, commands_container.get_child_count()):
		var child_to_remove = commands_container.get_child(i)
		if child_to_remove != first_child:
			child_to_remove.queue_free()
	
	add_line()
	
func add_line():
	
	var new_cli
	if computer.console_port_connection != null:
		if position == 0:
			new_cli = user_cli.instance()
		elif position == 1:
			if correct_pass == false:
				new_cli = password_line.instance()
				position = -1
			else:
				new_cli = priveleged_cli.instance()
		elif position == 2:
			new_cli = global_cli.instance()
		elif position == 3:
			new_cli = interface_cli.instance()
		elif position == 4:
			new_cli = routing_cli.instance()
		elif position == 5:
			new_cli = line_cli.instance()
	else:
		new_cli = default_cli.instance()

	if new_cli != null:
		commands_container.add_child(new_cli)
		if computer.console_port_connection != null:
			new_cli.find_node("cli_hbox").find_node("command_line").connect("enter_pressed", self, "_on_command_line_enter_pressed")
			new_cli.find_node("cli_hbox").find_node("command_line").grab_focus()
		else:
			new_cli.find_node("command_line").connect("enter_pressed", self, "_on_command_line_enter_pressed")
			new_cli.find_node("command_line").grab_focus()
		new_cli.find_node("result").connect("text_changed", self, "_on_result_text_changed")

func _on_command_line_enter_pressed(text, result_line):
	scan_command(text.to_lower(), result_line)
	result_line.rect_min_size.y = result_line.get_line_count() * result_line.get_line_height()
	level_scene.check_progress()

func starts_with(text, prefix):
	if text.length() < prefix.length():
		return false
	return text.substr(0, prefix.length()) == prefix
	
func has_property(obj, property_name):
	return typeof(obj) == TYPE_OBJECT && property_name in obj
	
func scan_command(command, result_line):
	var splitted_command = command.split(" ")
	if position == -1:
		if configurable_router != null:
			if command == configurable_router.priveleged_password:
				correct_pass = true
				position = 1
			else:
				position = 1
	elif position == 0:
		if command == "enable":
			position = 1
		else:
			result_line.text = "Unknown Command"
	elif position == 1:
		if command == "configure terminal":
			position = 2
		elif command == "exit":
			position -= 1
		else:
			result_line.text = "Unknown Command"
	elif position == 2:
		if starts_with(command, "interface"):
			if splitted_command[1] == "gigabitethernet0/0/0":
				to_be_configured = "ge0"
				position = 3
			elif splitted_command[1] == "gigabitethernet0/0/1":
				to_be_configured = "ge1"
				position = 3
			elif splitted_command[1] == "gigabitethernet0/0/2":
				to_be_configured = "ge2"
				position = 3
			elif splitted_command[1] == "serial0/0/0":
				to_be_configured = "se0"
				position = 3
			elif splitted_command[1] == "serial0/0/1":
				to_be_configured = "se1"
				position = 3
			elif splitted_command[1] == "serial0/0/2":
				to_be_configured = "se2"
				position = 3
			else:
				print("invalid interface")
		elif starts_with(command, "enable secret"):
			configurable_router.privileged_password = splitted_command[2]
		elif command == "exit":
			position -= 1
			correct_pass = false
		else:
			result_line.text = "Unknown Command"
	elif position == 3:
		if starts_with(command, "ip address"):
			if splitted_command[2] != null and splitted_command[3] != null:
				if to_be_configured == "ge0":
					configurable_router.ge0_ip = splitted_command[2]
					configurable_router.ge0_subnetMask = splitted_command[3]
				elif to_be_configured == "ge1":
					configurable_router.ge1_ip = splitted_command[2]
					configurable_router.ge1_subnetMask = splitted_command[3]
				elif to_be_configured == "ge2":
					configurable_router.ge2_ip = splitted_command[2]
					configurable_router.ge2_subnetMask = splitted_command[3]
			else:
				print("invalid input")
		elif command == "no shutdown":
			if to_be_configured == "ge0":
				configurable_router.ge0_port_up = true
				result_line.text = """%LINK-5-CHANGED: Interface GigabitEthernet0/0/0, changed state to up

%LINEPROTO-5-UPDOWN: Line protocol on Interface GigabitEthernet0/0/0, changed state to up"""
			elif to_be_configured == "ge1":
				configurable_router.ge1_port_up = true
				result_line.text = """%LINK-5-CHANGED: Interface GigabitEthernet0/0/1, changed state to up

%LINEPROTO-5-UPDOWN: Line protocol on Interface GigabitEthernet0/0/1, changed state to up"""
			elif to_be_configured == "ge2":
				configurable_router.ge2_port_up = true
				result_line.text = """%LINK-5-CHANGED: Interface GigabitEthernet0/0/2, changed state to up

%LINEPROTO-5-UPDOWN: Line protocol on Interface GigabitEthernet0/0/2, changed state to up"""
			result_line.text = "Unknown Command"
			
			
	add_line()

				
		
