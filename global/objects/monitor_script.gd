extends StaticBody

export var device_name : String
var fe0 : StaticBody = null
var fe0_type
var console_port0 : StaticBody
#var other_end : StaticBody
var isSaved = false
var test = "test"

signal cable_connected()

export(String) var device_type = "computer"
export(Array) var connected_to = []
export(String) var ip_allocation = "static"
export(String) var ipv4_address = "0.0.0.0"
export(String) var subnet_mask = "0.0.0.0"
export(String) var default_gateway = "0.0.0.0"
export(String) var dns_server = "0.0.0.0"
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
onready var exit_confirmation = $ui/ip_config_app/ip_config_screen/exit_confirmation

onready var ip_config_app = $ui/ip_config_app

onready var cmd_app = $ui/cmd_app
onready var cli_manager = $ui/cmd_app/cmd_screen/cli_manager
onready var commands_container = $ui/cmd_app/cmd_screen/main_panel/ScrollContainer/commands_container

onready var terminal_app = $ui/terminal_app

func _ready():
	if device_name.empty():
		device_name = self.name
	name_line_edit.text = device_name
	ipv4Add_lineEdit.connect("text_changed", self, "_on_line_edit_text_changed", [ipv4Add_lineEdit])
	ipv4Subnet_lineEdit.connect("text_changed", self, "_on_line_edit_text_changed", [ipv4Subnet_lineEdit])
	ipv4Gateway_lineEdit.connect("text_changed", self, "_on_line_edit_text_changed", [ipv4Gateway_lineEdit])
	ipv4Dns_lineEdit.connect("text_changed", self, "_on_line_edit_text_changed", [ipv4Dns_lineEdit])
	
func _on_line_edit_text_changed(line_edit, new_text):
	isSaved = false
	indicator_label.visible = false


func _on_name_lineEdit_text_changed(new_text):
	device_name = new_text
	
func _set_connector( connection, type ):
	if fe0 == null:
		fe0 = connection
		fe0_type = type
		label.text = "Connected to " + str(fe0.device_name) + "\nUsing: " + str(type)
		connected_to.append(fe0.device_name)
		emit_signal("cable_connected")
		
	else:
		pass
#	elif other_end == null:
#		other_end = connection

func _on_ipConfig_button_pressed():
	ip_config_app.visible = true


func _on_save_button_pressed():
	ipv4_address = ipv4Add_lineEdit.text
	subnet_mask = ipv4Subnet_lineEdit.text
	default_gateway = ipv4Gateway_lineEdit.text
	dns_server = ipv4Dns_lineEdit.text
	indicator_label.visible = true
	isSaved = true
	
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
