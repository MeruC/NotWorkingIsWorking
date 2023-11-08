extends Control

onready var video_player = $"../VideoPlayer"
var configure_router = preload("res://resources/video_tutorials/configure_router.webm")
var connecting_devices = preload("res://resources/video_tutorials/connecting_devices.webm")
var ip_configuration = preload("res://resources/video_tutorials/ip_configuration.webm")
var ping_device = preload("res://resources/video_tutorials/ping_device.webm")
var wire_crimping = preload("res://resources/video_tutorials/wire_crimping.webm")
var buying_materials = preload("res://resources/video_tutorials/buying_materials.webm")

func _on_connect_devices_pressed():
	video_player.set_stream(connecting_devices)
	video_player.visible = true
	video_player.play()


func _on_configure_ip_pressed():
	video_player.set_stream(ip_configuration)
	video_player.visible = true
	video_player.play()


func _on_ping_device_pressed():
	video_player.set_stream(ping_device)
	video_player.visible = true
	video_player.play()


func _on_configure_router_pressed():
	video_player.set_stream(configure_router)
	video_player.visible = true
	video_player.play()


func _on_VideoPlayer_finished():
	video_player.visible = false


func _on_back_button_pressed():
	video_player.stop()
	video_player.visible = false


func _on_tap_pressed():
	self.visible = false


func _on_open_tutorials_toggled(button_pressed):
	if button_pressed:
		self.visible = true
	else:
		self.visible = false


func _on_buying_materials_pressed():
	video_player.set_stream(buying_materials)
	video_player.visible = true
	video_player.play()


func _on_wire_crimping_pressed():
	video_player.set_stream(wire_crimping)
	video_player.visible = true
	video_player.play()
