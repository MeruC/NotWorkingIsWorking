extends Control

#signal on_ping_result_display("successful")
export(PackedScene) var command_line

onready var this_device = $"../../../.."
var passed_devices = []
signal device_pinged()
var command_entered
var size
var ipv4_add
onready var commands_container = $"../main_panel/ScrollContainer/commands_container"
onready var scroll_container = $"../main_panel/ScrollContainer"
var ping_successful_displays = """Pinging with 32 bytes of data:
	
Reply: bytes=32 time=1ms TTL=128
Reply: bytes=32 time<1ms TTL=128
Reply: bytes=32 time=1ms TTL=128
Reply: bytes=32 time=1ms TTL=128

Ping statistics:
	Packets: Sent = 4, Received = 4, Lost = 0 (0% Loss), 
Approximate round trip times in milli-seconds:
	Minimum = 0ms, Maximum = 1ms, Average = 0ms
"""
var ping_unsuccessful_displays = """Pinging with 32 bytes of data:

Request timed out.
Request timed out.
Request timed out.
Request timed out.

Ping statistics:
	Packets: Sent = 4, Received = 0, Lost = 4 (100% loss),"""


func _ready():
	size = get_tree().get_root().get_child_count() - 1
	set_process_input(true)
		
# To check what does the user intend to perform
func scan_command(command_entered):
	if command_entered.find("ping") == 0:
		return "ping"

# can add more conditions here
##

# To extract the ip address if the command is "ping"
func extract_ip(command_entered):
	var command_parts = command_entered.split(" ")
	if command_parts.size() == 2 and command_parts[0] == "ping":
		var ip_address = command_parts[1]
		return ip_address
##

# To ping a device with the inputted ip add
func ping_device(device_object, ipv4_add, current_device):
	passed_devices.append(current_device)
	if device_object.device_type == "computer" and device_object.ipv4_address == ipv4_add:
		return true
	elif device_object.device_type == "router" and (device_object.ge0_ip == ipv4_add or device_object.ge1_ip == ipv4_add or device_object.ge2_ip == ipv4_add):
		return true
	if device_object.connected_to.size() != 0:
		for another_device in device_object.connected_to:
			if another_device in passed_devices:
				pass
			else:
				var new_device_object
				for child in get_tree().get_root().get_child(size).get_children():
					if child is StaticBody and has_property(child, "device_name") and child.device_name == another_device:
						new_device_object = child
				if ping_device(new_device_object, ipv4_add, device_object.device_name):
					return true
	return false

func _on_command_line_enter_pressed(text, result_line):
	if scan_command(text) == "ping":
		if this_device.ipv4_address == extract_ip(text):
			result_line.text = ping_successful_displays
			result_line.rect_min_size.y = result_line.get_line_count() * result_line.get_line_height()
		elif this_device.connected_to.size() != 0:
			for device_name in this_device.connected_to:
				if device_name != this_device.device_name:
					var device_object
					for child in get_tree().get_root().get_child(size).get_children():
						if child is StaticBody and has_property(child, "device_name") and child.device_name == device_name:
							device_object = child
					if device_object != null:
						#print(device_object)
						if ping_device(device_object, extract_ip(text), this_device.device_name) == true:
							result_line.text = ping_successful_displays
							result_line.rect_min_size.y = result_line.get_line_count() * result_line.get_line_height()
							emit_signal("device_pinged")
						else:
							result_line.text = ping_unsuccessful_displays
							result_line.rect_min_size.y = result_line.get_line_count() * result_line.get_line_height()
					else:
						result_line.text = ping_unsuccessful_displays
						result_line.rect_min_size.y = result_line.get_line_count() * result_line.get_line_height()
		else:
			result_line.text = ping_unsuccessful_displays
			result_line.rect_min_size.y = result_line.get_line_count() * result_line.get_line_height()
	add_cmd_line()

	#for child in get_tree().get_root().get_child(size).get_children():
	#	if child is StaticBody and child.get("ipv4_address") != null and child.get("ipv4_address") == ipv4_add and child.device_name in this_device.connected_to:
	#		return true
	#	elif child.connected_to != null:
	#		for device_name in child.connected_to:
	#			for device in get_tree().get_root().get_child(size).get_children():
	#				if device.device_name == device_name:
	#					if device.device_type == "computer" and device.ipv4_add == ipv4_add:
	#						return true
	#					elif device.device_type == "router" and (device.ge0_ip == ipv4_add or device.ge1_ip == ipv4_add or device.ge2_ip == ipv4_add):
	#						return true
	#return false
##

func has_property(obj, property_name):
	return typeof(obj) == TYPE_OBJECT && property_name in obj

# To add another editable lineEdit in cmd
func add_cmd_line():
	var new_command_line = command_line.instance()
	if new_command_line != null:
		commands_container.add_child(new_command_line)
		new_command_line.find_node("command_line_container").find_node("command_line").connect("enter_pressed", self, "_on_command_line_enter_pressed")
		new_command_line.find_node("command_line_container").find_node("command_line").grab_focus()
		scroll_container.ensure_control_visible(new_command_line)
#
	
func starts_with(text, prefix):
	if text.length() < prefix.length():
		return false
	return text.substr(0, prefix.length()) == prefix
