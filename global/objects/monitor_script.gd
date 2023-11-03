extends StaticBody

onready var level_scene = get_tree().get_root().get_child(get_tree().get_root().get_child_count()-1)

export var device_name : String
var fe0 : StaticBody = null
var fe0_type
var console_port0 : StaticBody
var console_portType
#var other_end : StaticBody
var isSaved = false
var test = "test"
var rj = true
var console = true
var main_scene

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

#export(String) var ipv6_allocation = "static"
#export(Array) var link_local_address = [0, 0, 0, 0]
#export(Array) var subnet_mask = [0, 0, 0, 0]
#export(Array) var default_gateway = [0, 0, 0, 0]
#export(Array) var dns_server = [0, 0, 0, 0]

onready var label = $ui/pc_screen/holder/Label
onready var name_line_edit = $ui/pc_screen/holder/name_lineEdit
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

onready var ip_config_app = $ui/ip_config_app

onready var cmd_app = $ui/cmd_app
onready var cli_manager = $ui/cmd_app/cmd_screen/cli_manager
onready var commands_container = $ui/cmd_app/cmd_screen/main_panel/ScrollContainer/commands_container

onready var terminal_app = $ui/terminal_app

onready var disconnect_popup = $ui/disconnect_confirm
onready var disconnect_confirm = $ui/disconnect_confirm/ColorRect2/ColorRect/MarginContainer/VBoxContainer/confirm/confirm
onready var disconnectTo_label = $ui/disconnect_confirm/ColorRect2/ColorRect/MarginContainer/VBoxContainer/HBoxContainer/device_name
onready var fe_cable = $ui/io/cpu_ui/fe_cable
onready var fe_disconnectBtn = $ui/io/cpu_ui/disconnect_button
onready var ui_script = preload("res://global/objects/scripts/pc_ui.gd")

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

func _ready():
	main_scene = get_tree().get_root().get_child(get_tree().get_root().get_child_count()-1).get_children()
	
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
		label.text = "Connected to " + str(fe0.device_name) + "\nUsing: " + str(type)
		connected_to.append(fe0.device_name)
		level_scene.check_progress()
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
		console_portType = type
		label.text = "Connected to " + str(console_port0.device_name) + "\nUsing: " + str(type)
		connected_to.append(console_port0.device_name)
		#emit_signal("cable_connected")
	else:
		pass
#	elif other_end == null:
#		other_end = connection

func _on_ipConfig_button_pressed():
	ip_config_app.visible = true


func _on_save_button_pressed():
	if ip_indicator.visible == false:
		ipv4_address = ipv4Add_lineEdit.text
		subnet_mask = ipv4Subnet_lineEdit.text
		default_gateway = ipv4Gateway_lineEdit.text
		dns_server = ipv4Dns_lineEdit.text
		indicator_label.visible = true
		error_label.visible = false
		isSaved = true
		emit_signal("configuration_saved")
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

func _on_static_radio_pressed():
	uncheck_other(dhcp_radio)
	toggle_lineEdits()
		
func toggle_lineEdits():
	if ipv4Add_lineEdit.editable == true:
		ipv4Add_lineEdit.editable = false
		ipv4Add_lineEdit.max_length = 0
		ipv4Add_lineEdit.text = "Retrieving IP Address..."
		ipv4Subnet_lineEdit.editable = false
		ipv4Subnet_lineEdit.max_length = 0
		ipv4Subnet_lineEdit.text = "Retrieving Subnet Mask..."
	else:
		ipv4Add_lineEdit.editable = true
		ipv4Add_lineEdit.max_length = 15
		ipv4Add_lineEdit.text = ""
		ipv4Subnet_lineEdit.editable = true
		ipv4Subnet_lineEdit.max_length = 15
		ipv4Subnet_lineEdit.text = ""

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
	disconnectTo_label.text = fe0.device_name
	disconnect_popup.visible = true

func _on_confirm_pressed():
	if fe0.device_type == "computer":
		fe0.fe0 = null
		fe0.fe0_type = null
	elif fe0.device_type == "router":
		if fe0.ge0 == device_name:
			fe0.ge0 = null
			fe0.ge0_type = null
		elif fe0.ge1 == device_name:
			fe0.ge1 = null
			fe0.ge1_type = null
		elif fe0.ge2 == device_name:
			fe0.ge2 = null
			fe0.ge2_type = null
	
	return_cable()
	fe0 = null
	fe0_type = null
	label.text = ""
	fe_cable.visible = false
	fe_disconnectBtn.visible = false
##

func return_cable():
	var produce = [{
		"id":fe0_type,
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
				if int(splitted_ip[0]) >= 0 and int(splitted_ip[0]) <= 127:
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
