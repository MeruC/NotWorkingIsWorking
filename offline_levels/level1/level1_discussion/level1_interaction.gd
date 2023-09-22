extends Area

export( String ) var pc_name
export(Resource) var setting_data
var inventory : Inventory
var action = "open"
var object_name = "Chest"

func _ready():
	object_name = pc_name

func interact():
	$"../../ui".visible = true
	$"../../ui/message".text = "Welcome "+setting_data.player_name+" are you ready to gain new things about networking?"
	SignalManager.emit_signal( "pc_opened")

func out_of_range():
	SignalManager.emit_signal( "pc_closed")


func _on_yes_pressed():
	SignalManager.emit_signal( "pc_closed")
	get_tree().change_scene("res://offline_levels/level1/level1_discussion/level1_discussion.tscn")


func _on_no_pressed():
	SignalManager.emit_signal( "pc_closed")
