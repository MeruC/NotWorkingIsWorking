extends Control

#signal on_ping_result_display("successful")
export(PackedScene) var command_line

signal device_pinged()
var command_entered
var size
var ipv4_add
onready var commands_container = $"../main_panel/ScrollContainer/commands_container"
onready var root_scene = $"../../../.."
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

func _input(event):
	pass

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
func ping_device(ipv4_add):
	for child in get_tree().get_root().get_child(size).get_children():
		if child is StaticBody and child.get("ipv4_address") != null and child.get("ipv4_address") == ipv4_add and child.device_name in root_scene.connected_to:
			return true
	return false
##



func _on_command_line_enter_pressed(text, result_line):
	if scan_command(text) == "ping":
		if ping_device(extract_ip(text)) == true:
			result_line.text = ping_successful_displays
			result_line.rect_min_size.y = result_line.get_line_count() * result_line.get_line_height()
			emit_signal("device_pinged")
		else:
			result_line.text = ping_unsuccessful_displays
			result_line.rect_min_size.y = result_line.get_line_count() * result_line.get_line_height()
	add_cmd_line()


# To add another editable lineEdit in cmd
func add_cmd_line():
	var new_command_line = command_line.instance()
	if new_command_line != null:
		commands_container.add_child(new_command_line)
		new_command_line.find_node("command_line_container").find_node("command_line").connect("enter_pressed", self, "_on_command_line_enter_pressed")
#
	
