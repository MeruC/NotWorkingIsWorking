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
	$"../../ui/AnimationPlayer".play("loading_anim")
	SignalManager.emit_signal( "pc_opened")

func out_of_range():
	SignalManager.emit_signal( "pc_closed")


func _on_AnimationPlayer_animation_finished(anim_name):
	$"../../ui/level_selection".visible = true
	$"../../ui/cat_loading".visible = false
	$"../../ui/loading_text".visible = false
	$"../../ui/bg2".visible = false
