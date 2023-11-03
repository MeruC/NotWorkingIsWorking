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
	elif ge1 == null:
		ge1 = connection
		ge1_type = type
		#label.text = "Connected to " + str(ge1.device_name) + "\nUsing: " + str(type)
		connected_to.append(ge1.device_name)
	elif ge2 == null:
		ge2 = connection
		ge2_type = type
		#label.text = "Connected to " + str(ge2.device_name) + "\nUsing: " + str(type)
		connected_to.append(ge2.device_name)
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
