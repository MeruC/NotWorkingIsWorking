extends StaticBody

onready var level_scene = get_parent()

export var device_name : String
var fe0 : StaticBody = null
var fe0_type
var console_port0 : StaticBody
var console_portType
#var other_end : StaticBody
var isSaved = false#onready var cables = $"%cables"
var test = "test"
var rj = true
var console = true
var main_scene
var devices = []
var connected_router
onready var draw = $draw

var cross = preload("res://addons/Line3D/cross_over.tres")
var straight = preload("res://addons/Line3D/straight_through.tres")

signal configuration_saved()

signal cable_connected()

export(String) var device_type = "computer"
export(Array) var connected_to = []
export(String) var ip_allocation = "static"
export(String) var ipv4_address
export(String) var subnet_mask
export(String) var default_gateway
export(String) var dns_server
export(String) var console_port_connection = null

onready var fe_0_line = $fe0/fe0line
onready var console_0_line = $console0/console0line

#export(String) var ipv6_allocation = "static"
#export(Array) var link_local_address = [0, 0, 0, 0]
#export(Array) var subnet_mask = [0, 0, 0, 0]
#export(Array) var default_gateway = [0, 0, 0, 0]
#export(Array) var dns_server = [0, 0, 0, 0]

onready var label = $ui/pc_screen/holder/Label
onready var name_line_edit = $ui/pc_screen/holder/name_lineEdit
onready var deviceName_lineEdit = $ui/ip_config_app/ip_config_screen/main_panel/content_panel/device_name_hbox/deviceName_lineEdit
onready var dhcp_radio = $ui/ip_config_app/ip_config_screen/main_panel/content_panel/ipv4_config_hbox/radio_buttons/dhcp_radio
onready var static_radio = $ui/ip_config_app/ip_config_screen/main_panel/content_panel/ipv4_config_hbox/radio_buttons/static_radio
onready var ipv4Add_lineEdit = $ui/ip_config_app/ip_config_screen/main_panel/content_panel/ipv4_config_hbox/ip_hbox/ipAdd_lineEdit
onready var ipv4Subnet_lineEdit = $ui/ip_config_app/ip_config_screen/main_panel/content_panel/ipv4_config_hbox/subnet_hbox/subnet_lineEdit
onready var ipv4Gateway_lineEdit = $ui/ip_config_app/ip_config_screen/main_panel/content_panel/ipv4_config_hbox/gateway_hbox/gateway_lineEdit
onready var ipv4Dns_lineEdit = $ui/ip_config_app/ip_config_screen/main_panel/content_panel/ipv4_config_hbox/dns_hbox2/dns_lineEdit
onready var ipv4_vbox = $ui/ip_config_app/ip_config_screen/main_panel/content_panel/ipv4_config_hbox
onready var indicator_label = $ui/ip_config_app/ip_config_screen/main_panel/indicator_label
onready var error_label = $ui/ip_config_app/ip_config_screen/main_panel/error_label
onready var exit_confirmation = $ui/ip_config_app/ip_config_screen/exit_confirmation
onready var ip_indicator = $ui/ip_config_app/ip_config_screen/main_panel/ip_indicator
onready var dhcp_timer = $ui/ip_config_app/ip_config_screen/dhcp_timer
onready var ip_config_app = $ui/ip_config_app

onready var cmd_app = $ui/cmd_app
onready var cli_manager = $ui/cmd_app/cmd_screen/cli_manager
onready var commands_container = $ui/cmd_app/cmd_screen/main_panel/ScrollContainer/commands_container

onready var terminal_app = $ui/terminal_app

onready var disconnect_popup = $ui/disconnect_confirm
onready var disconnect_confirm = $ui/disconnect_confirm/ColorRect2/ColorRect/MarginContainer/VBoxContainer/confirm/confirm
onready var disconnectTo_label = $ui/disconnect_confirm/ColorRect2/ColorRect/MarginContainer/VBoxContainer/HBoxContainer/device_name
onready var cableType_label = $ui/disconnect_confirm/ColorRect2/ColorRect/MarginContainer/VBoxContainer/HBoxContainer2/cable_type
onready var fe_cable = $ui/io/cpu_ui/fe_cable
onready var fe_disconnectBtn = $ui/io/cpu_ui/disconnect_button
onready var console_cable = $ui/io/cpu_ui/console_cable
onready var consolde_disconnectBtn = $ui/io/cpu_ui/disconnect_console
onready var ui_script = load("res://global/objects/scripts/pc_ui.gd")

func resetLevel():
	SaveManager.load_game()
	if device_name.empty():
		device_name = self.name
	#if fe0 != null:
	#	return_cable(fe0_type)
	fe0 = null
	fe0_type = null
	#if console_port0 != null:
	#	return_cable("Console_Cable")
	console_port0 = null
	console_portType = null
	#other_end : StaticBody
	isSaved = false
	test = "test"
	rj = true
	console = true

	device_type = "computer"
	connected_to = []
	ip_allocation = "static"
	ipv4_address = ""
	subnet_mask = ""
	default_gateway = ""
	dns_server = ""
	console_port_connection = ""

var p = Array()
onready var fe0_point = $fe0/fe0point
onready var console0_point = $console0/console0point

func _process(delta):
	pass
	
func checkports():
	if console_port0 == null:
		console = true
	else:
		console = false
	if fe0 == null:
		rj = true
	else:
		rj = false

func get_devices():
	for node in self.get_parent().get_children():
		if "Router" in node.name or "monitor" in node.name:
			devices.append(node)

func _ready():
	get_devices()
	#resetLevel()
	main_scene = self.get_parent()
	
	if device_name.empty():
		device_name = self.name
	name_line_edit.text = device_name
	ipv4Add_lineEdit.connect("text_changed", self, "_on_line_edit_text_changed", [ipv4Add_lineEdit])
	ipv4Subnet_lineEdit.connect("text_changed", self, "_on_line_edit_text_changed", [ipv4Subnet_lineEdit])
	ipv4Gateway_lineEdit.connect("text_changed", self, "_on_line_edit_text_changed", [ipv4Gateway_lineEdit])
	ipv4Dns_lineEdit.connect("text_changed", self, "_on_line_edit_text_changed", [ipv4Dns_lineEdit])
	disconnect_confirm.connect("pressed", self, "_on_confirm_pressed")
	
func _on_line_edit_text_changed(line_edit, new_text):
	isSaved = false
	indicator_label.visible = false


func _on_name_lineEdit_text_changed(new_text):
	device_name = new_text
	
func _set_connector( connection, type ):
	if fe0 == null:
		fe0 = connection
		fe0_type = str(type)
		#label.text = "Connected to " + str(fe0.device_name) + "\nUsing: " + str(type)
		connected_to.append(fe0.device_name)
		
		level_scene.check_progress()
		print(self.translation)
		print(fe0.translation)
		print(self.translation.distance_to(fe0.translation))
		#if fe0 != null:
		fe0_point.global_translation = fe0.global_translation
		fe_0_line.visible = true
		if fe0_type == "cross_over":
			fe_0_line.set_material_override(cross)
		elif fe0_type == "straight_through":
			fe_0_line.set_material_override(straight)
		#if console_port0 != null:
		#emit_signal("cable_connected")
	else:
		pass
#	elif other_end == null:
#		other_end = connection

func has_property(obj, property_name):
	return typeof(obj) == TYPE_OBJECT && property_name in obj

func _set_connectorConsole( connection, type ):
	if console_port0 == null:
		console_port0 = connection
		console_port_connection = connection.device_name
		console_portType = type
		console0_point.global_translation = console_port0.global_translation
		#label.text = "Connected to " + str(console_port0.device_name) + "\nUsing: " + str(type)
		#emit_signal("cable_connected")
		console_0_line.visible = true
		
	else:
		pass
#	elif other_end == null:
#		other_end = connection

func _on_ipConfig_button_pressed():
	deviceName_lineEdit.text = device_name
	ipv4Add_lineEdit.text = ipv4_address
	ipv4Subnet_lineEdit.text = subnet_mask
	ipv4Gateway_lineEdit.text = default_gateway
	dns_server = ipv4Dns_lineEdit.text
	indicator_label.visible = false
	ip_indicator.visible = false
	if ip_allocation == "dhcp":
		dhcp_radio.pressed = true
		dhcp_radio.disabled = true
		static_radio.pressed = false
	else:
		dhcp_radio.pressed = false
		static_radio.pressed = true
		static_radio.disabled = true	
	ip_config_app.visible = true


func _on_save_button_pressed():
	if ip_indicator.visible == false:
		ipv4_address = ipv4Add_lineEdit.text
		subnet_mask = ipv4Subnet_lineEdit.text
		default_gateway = ipv4Gateway_lineEdit.text
		dns_server = ipv4Dns_lineEdit.text
		indicator_label.visible = true
		error_label.visible = false
		if dhcp_radio.pressed == true:
			ip_allocation = "dhcp"
		elif static_radio.pressed == true:
			ip_allocation = "static"
		isSaved = true
		emit_signal("configuration_saved")
		level_scene.check_progress()
	else:
		error_label.visible = true
		indicator_label.visible = false
	
func validInt_checker(iterable):
	for item in iterable:
		if !item.is_valid_int():
			return false
	return true


func _on_dhcp_radio_pressed():
	uncheck_other(static_radio)
	toggle_lineEdits()
	dhcp_timer.start(3)

func _on_static_radio_pressed():
	uncheck_other(dhcp_radio)
	toggle_lineEdits()
	dhcp_timer.stop()
		
func toggle_lineEdits():
	if ipv4Add_lineEdit.editable == true:
		ipv4Add_lineEdit.editable = false
		ipv4Add_lineEdit.max_length = 0
		ipv4Add_lineEdit.text = "Retrieving IP Address..."
		ipv4Add_lineEdit.focus_mode = Control.FOCUS_NONE
		ipv4Subnet_lineEdit.editable = false
		ipv4Subnet_lineEdit.max_length = 0
		ipv4Subnet_lineEdit.text = "Retrieving Subnet Mask..."
		ipv4Gateway_lineEdit.editable = false
		ipv4Dns_lineEdit.editable = false
		dhcp_radio.disabled = true
		static_radio.disabled = false
	else:
		ipv4Add_lineEdit.editable = true
		ipv4Add_lineEdit.max_length = 15
		ipv4Add_lineEdit.text = ""
		ipv4Add_lineEdit.focus_mode = Control.FOCUS_ALL
		ipv4Subnet_lineEdit.editable = true
		ipv4Subnet_lineEdit.max_length = 15
		ipv4Subnet_lineEdit.text = ""
		ipv4Gateway_lineEdit.editable = true
		ipv4Dns_lineEdit.editable = true
		static_radio.disabled = true
		dhcp_radio.disabled = false

func uncheck_other(radio):
	radio.pressed = false


func _on_exit_confirmation_confirmed():
	ip_config_app.visible = false
	indicator_label.visible = false



func _on_cmd_button_pressed():
	cmd_app.visible = true
	cli_manager.add_cmd_line()


func _on_ipConfig_close_button_pressed():
	if isSaved == false:
		exit_confirmation.visible = true
	else:
		ip_config_app.visible = false
		indicator_label.visible = false


func _on_cmd_close_button_pressed():
	cmd_app.visible = false
	for i in range(1, commands_container.get_child_count()):
		commands_container.get_child(i).queue_free()


func _on_terminal_button_pressed():
	terminal_app.visible = true


func _on_terminal_close_button_pressed():
	terminal_app.visible = false

# CPU Scripts

func _on_disconnect_button_pressed():
	disconnectTo_label.text = fe0.device_name + "?"
	if fe0_type == "straight_through":
		cableType_label.text = "Straight-Through"
	elif fe0_type == "cross_over":
		cableType_label.text = "Cross-Over"
	disconnect_popup.visible = true

func _on_disconnect_console_pressed():
	disconnectTo_label.text = console_port_connection + "?"
	cableType_label.text = "Console"
	disconnect_popup.visible = true

func _on_confirm_pressed():
	if cableType_label.text == "Cross-Over" or cableType_label.text == "Straight-Through":
		if fe0.device_type == "computer":
			fe0.fe_0_line.visible = false
			fe0.fe0 = null
			fe0.fe0_type = null
		elif fe0.device_type == "router":
			if fe0.ge0.device_name == device_name:
				fe0.ge_0_line.visible = false
				fe0.ge0 = null
				fe0.ge0_type = null
			elif fe0.ge1.device_name == device_name:
				fe0.ge_1_line.visible = false
				fe0.ge1 = null
				fe0.ge1_type = null
			elif fe0.ge2.device_name == device_name:
				fe0.ge_2_line.visible = false
				fe0.ge2 = null
				fe0.ge2_type = null
		if fe0.connected_to.has(device_name):
			fe0.connected_to.remove(device_name)
		return_cable(fe0_type)
		fe_0_line.visible = false
		fe0 = null
		fe0_type = null
		#label.text = ""
		fe_cable.visible = false
		fe_disconnectBtn.visible = false
	elif cableType_label.text == "Console":
		console_port0.console_0_line.visible = false
		console_port0.console_port0 = null
		console_port0.console_portType = null
		return_cable("Console_Cable")
		console_port0 = null
		console_portType = null
		#label.text = ""
		console_cable.visible = false
		consolde_disconnectBtn.visible = false
		console_0_line.visible = false
##

func return_cable(cable_type):
	var produce = [{
		"id":cable_type,
		"quantity": 1
	}]
	InventoryManager.add_items(ItemManager.get_items(produce), "player")
	SaveManager.save_game()


func _on_ipAdd_lineEdit_focus_exited():
	var splitted_ip = ipv4Add_lineEdit.text.split(".")
	if splitted_ip.size() == 4:
		for octet in splitted_ip:
			if octet.length() > 3 and int(octet) < 0:
				pass
			else:
				if int(splitted_ip[0]) >= 1 and int(splitted_ip[0]) <= 127:
					ipv4Subnet_lineEdit.text = "255.0.0.0"
					ip_indicator.visible = false
					return
				elif int(splitted_ip[0]) >= 128 and int(splitted_ip[0]) <= 191:
					ipv4Subnet_lineEdit.text = "255.255.0.0"
					ip_indicator.visible = false
					return
				elif int(splitted_ip[0]) >= 192 and int(splitted_ip[0]) <= 223:
					ipv4Subnet_lineEdit.text = "255.255.255.0"
					ip_indicator.visible = false
					return
	ip_indicator.visible = true
	ipv4Add_lineEdit.text = ""
	ipv4Subnet_lineEdit.text = ""
	return


func find_connected_router():
	if connected_to.size() != 0:
		for x in connected_to:
			for device in devices:
				if device.device_name == x and device.device_type == "router":
					return device

func _on_dhcp_timer_timeout():
	var connected_router = find_connected_router()
	if connected_router != null:
		if connected_router.dhcp_pools.size() != 0:
			var new_ip
			if connected_router.dhcp_pools[0]["low_ip"] != null:
				new_ip = connected_router.dhcp_pools[0]["low_ip"]
			for device in devices:
				if device.device_type == "computer":
					while device.ipv4_address == new_ip:
						new_ip = increment_ip(new_ip)
			ipv4Add_lineEdit.text = new_ip
			var splitted_new_ip = new_ip.split(".")
			if int(splitted_new_ip[0]) >= 0 and int(splitted_new_ip[0]) <= 127:
				ipv4Subnet_lineEdit.text = "255.0.0.0"
				ip_indicator.visible = false
			elif int(splitted_new_ip[0]) >= 128 and int(splitted_new_ip[0]) <= 191:
				ipv4Subnet_lineEdit.text = "255.255.0.0"
				ip_indicator.visible = false
			elif int(splitted_new_ip[0]) >= 192 and int(splitted_new_ip[0]) <= 223:
				ipv4Subnet_lineEdit.text = "255.255.255.0"
				ip_indicator.visible = false
				
			if connected_router.dhcp_pools[0]["dns-server"] != null:
				ipv4Dns_lineEdit.text = connected_router.dhcp_pools[0]["dns-server"]
			
			if connected_router.dhcp_pools[0]["gateway"] != null:
				ipv4Gateway_lineEdit.text = connected_router.dhcp_pools[0]["gateway"]
		else:
			ipv4Add_lineEdit.text = "Unable to obtain IP Address"
			ipv4Subnet_lineEdit.text = ""
			ip_indicator.visible = true
	else:
			ipv4Add_lineEdit.text = "Unable to obtain IP Address"
			ipv4Subnet_lineEdit.text = ""
			ip_indicator.visible = true

func increment_ip(ip):
	var splitted_ip = ip.split(".")
	splitted_ip[3] = str(int(splitted_ip[3]) + 1 )
	var new_ip = splitted_ip.join(".")
	return new_ip
