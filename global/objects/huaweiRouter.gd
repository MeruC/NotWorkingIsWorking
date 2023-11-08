extends StaticBody

var ge0 : StaticBody
var ge0_type
var ge1 : StaticBody
var ge1_type
var ge2 : StaticBody
var ge2_type
var console_port0 : StaticBody
var console_portType
var other_end : StaticBody
var fe0 = "asda"
var rj = true
var console = true
var dhcp_pools = []


var cross = preload("res://addons/Line3D/cross_over.tres")
var straight = preload("res://addons/Line3D/straight_through.tres")

onready var ge_0_line = $ge/ge0line
onready var pointge_0 = $ge/pointge0
onready var ge_1_line = $ge/ge1line
onready var pointge_1 = $ge/pointge1
onready var ge_2_line = $ge/ge2line
onready var pointge_2 = $ge/pointge2
onready var console_0_line = $console0/console0line
onready var console_0_point = $console0/console0point


export(String) var priveleged_password = null
export(String) var device_type = "router"
export(String) var device_name = self.name
export(String) var ge0_ip
export(String) var ge0_subnetMask
export(bool) var ge0_port_up = false
export(String) var ge1_ip 
export(String) var ge1_subnetMask
export(bool) var ge1_port_up = false
export(String) var ge2_ip
export(String) var ge2_subnetMask
export(bool) var ge2_port_up = false
export(String) var console_port_connection = null
export(int) var port_count = 3
export(Array) var connected_to = []

func reset_level():
	SaveManager.load_game()
	ge0 = null
	ge0_type = null
	ge1 = null
	ge1_type = null
	ge2 = null
	ge2_type = null
	console_port0 = null
	console_portType = null
	other_end = null
	fe0 = "asda"
	rj = true
	console = true
	dhcp_pools = []

	priveleged_password = null
	device_type = "router"
	device_name = self.name
	ge0_ip = ""
	ge0_subnetMask = ""
	ge0_port_up = false
	ge1_ip  = ""
	ge1_subnetMask = ""
	ge1_port_up = false
	ge2_ip = ""
	ge2_subnetMask = ""
	ge2_port_up = false
	console_port_connection = null
	port_count = 3
	connected_to = []

func _ready():
	#reset_level()
	pass

#Checks if all ports are in use
func checkports():
	if console_port0 == null:
		console = true
	else:
		console = false
	if ge0 == null or ge1 == null or ge2 == null:
		rj = true
	else:
		rj = false

func _set_connector( connection , type):
	if ge0 == null:
		ge0 = connection
		ge0_type = type
		#label.text = "Connected to " + str(ge0.device_name) + "\nUsing: " + str(type)
		connected_to.append(ge0.device_name)
		pointge_0.global_translation = ge0.global_translation
		if ge0_type == "cross_over":
			ge_0_line.set_material_override(cross)
		elif ge0_type == "straight_through":
			ge_0_line.set_material_override(straight)
	elif ge1 == null:
		ge1 = connection
		ge1_type = type
		#label.text = "Connected to " + str(ge1.device_name) + "\nUsing: " + str(type)
		connected_to.append(ge1.device_name)
		pointge_1.global_translation = ge1.global_translation
		if ge1_type == "cross_over":
			ge_1_line.set_material_override(cross)
		elif ge1_type == "straight_through":
			ge_1_line.set_material_override(straight)
	elif ge2 == null:
		ge2 = connection
		ge2_type = type
		#label.text = "Connected to " + str(ge2.device_name) + "\nUsing: " + str(type)
		connected_to.append(ge2.device_name)
		pointge_2.global_translation = ge2.global_translation
		if ge2_type == "cross_over":
			ge_2_line.set_material_override(cross)
		elif ge2_type == "straight_through":
			ge_2_line.set_material_override(straight)
	else:
		print("no port available")
		
	connected_to.append(connection.device_name)
	print(connected_to)

func _set_connectorConsole( connection, type ):
	if console_port0 == null:
		console_port0 = connection
		console_portType = type
		#label.text = "Connected to " + str(console_port0.device_name) + "\nUsing: " + str(type)
		connected_to.append(console_port0.device_name)
		console_0_point.global_translation = console_port0.global_translation
		#emit_signal("cable_connected")
	else:
		pass
#	elif other_end == null:
#		other_end = connection
