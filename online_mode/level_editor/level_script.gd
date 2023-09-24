extends Spatial

var player
onready var mobile_controls = $"%mobile_controls"
onready var inventory = $"%inventory"

var joystick
export (Resource) var setting_data
var lesson = preload("res://offline_levels/level1/level1_discussion/level1_discussion.tscn")

func _ready():
	if get_parent().name != "editor":
		inventory.set_visible(true)
		mobile_controls.set_visible(true)
		if setting_data.gender == "male":
			player = preload("res://global/Player/Player.tscn")
			add_child(player.instance())
		elif setting_data.gender == "female":
			player = preload("res://global/Player_girl/player-girl.tscn")
			add_child(player.instance())
		
		
	SignalManager.connect( "pc_opened", self, "_on_pc_opened" )
	SignalManager.connect( "pc_closed", self, "_on_pc_closed" )

func _on_pc_opened():
	joystick = get_node("mobile_controls/joystick")
	
	#player = main.get_node("Player")
	
	#inventory.set_visible(false)
	mobile_controls.set_visible(true)
	joystick.use_input_actions = true
	
func _on_pc_closed():
	inventory = get_node("inventory/ui")
	mobile_controls = get_node("mobile_controls")
	joystick = get_node("mobile_controls/joystick")
	#player = main.get_node("Player")
	
	#inventory.set_visible(true)
	mobile_controls.set_visible(true)
	joystick.use_input_actions = true
