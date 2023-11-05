extends StaticBody

var ge0 : StaticBody
var ge0_type
var ge1 : StaticBody
var ge1_type
var console_port0 : StaticBody
var console_portType
var other_end : StaticBody
var fe0 = "asda"
var rj = true
var console = true
var dhcp_pools = []

export(String) var priveleged_password = null
export(String) var device_type = "router"
export(String) var device_name = self.name
export(String) var ge0_ip
export(String) var ge0_subnetMask
export(bool) var ge0_port_up = false
export(String) var ge1_ip 
export(String) var ge1_subnetMask
export(bool) var ge1_port_up = false
export(String) var console_port_connection = null
export(int) var port_count = 2
export(Array) var connected_to = []

func reset_level():
	SaveManager.load_game()
	ge0 = null
	ge0_type = null
	ge1 = null
	ge1_type = null
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
	console_port_connection = null
	port_count = 2
	connected_to = []

func _ready():
	reset_level()

#Checks if all ports are in use
func checkports():
	if console_port0 == null:
		console = true
	else:
		console = false
	if ge0 == null or ge1 == null:
		rj = true
	else:
		rj = false

func _set_connector( connection , type):
	if ge0 == null:
		ge0 = connection
		ge0_type = type
		#label.text = "Connected to " + str(ge0.device_name) + "\nUsing: " + str(type)
		connected_to.append(ge0.device_name)
	elif ge1 == null:
		ge1 = connection
		ge1_type = type
		#label.text = "Connected to " + str(ge1.device_name) + "\nUsing: " + str(type)
		connected_to.append(ge1.device_name)
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
		#emit_signal("cable_connected")
	else:
		pass
#	elif other_end == null:
#		other_end = connection
