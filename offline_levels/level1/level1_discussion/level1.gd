extends Spatial

var player
var inventory
var mobile_controls
var joystick
export (Resource) var setting_data
var lesson = preload("res://offline_levels/level1/level1_discussion/level1_discussion.tscn")

func _ready():
	match(setting_data.gender):
		"male":
			player = preload("res://global/Player/Player.tscn")
			add_child(player.instance())
		"female":
			player = preload("res://global/Player_girl/player-girl.tscn")
			add_child(player.instance())
	SignalManager.connect( "pc_opened", self, "_on_pc_opened" )
	SignalManager.connect( "pc_closed", self, "_on_pc_closed" )
	

func _on_pc_opened():
	mobile_controls = get_node("mobile_controls")
	joystick = get_node("mobile_controls/joystick")
	
	#player = main.get_node("Player")
	
	#inventory.set_visible(false)
	mobile_controls.set_visible(true)
	joystick.use_input_actions = true
	
func _on_pc_closed():
	mobile_controls = get_node("mobile_controls")
	joystick = get_node("mobile_controls/joystick")
	#player = main.get_node("Player")
	
	#inventory.set_visible(true)
	mobile_controls.set_visible(true)
	joystick.use_input_actions = true


func _on_level_selection_tree_exited():
	queue_free()
