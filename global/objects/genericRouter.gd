extends StaticBody

var ge0 : StaticBody
var ge1 : StaticBody
var ge2 : StaticBody
var other_end : StaticBody

export(String) var priveleged_password = null
export(String) var device_type = "router"
export(String) var device_name = "router0"
export(String) var ge0_ip = "0.0.0.0"
export(String) var ge0_subnetMask = "0.0.0.0"
export(bool) var ge0_port_up = false
export(String) var ge1_ip = "0.0.0.0"
export(String) var ge1_subnetMask = "0.0.0.0"
export(bool) var ge1_port_up = false
export(String) var ge2_ip = "0.0.0.0"
export(String) var ge2_subnetMask = "0.0.0.0"
export(bool) var ge2_port_up = false
export(String) var console_port_connection = null
export(int) var port_count = 3
export(Array) var connected_to = []

func _set_connector( connection ):
	if ge0 == null:
		ge0 = connection
		emit_signal("cable_connected")
	elif ge1 == null:
		ge1 = connection
		emit_signal("cable_connected")
	elif ge2 == null:
		ge2 = connection
		emit_signal("cable_connected")
	else:
		print("no port available")
	connected_to.append(connection.device_name)
	print(connected_to)
