extends Spatial

const SAVE_FOLDER = "user://saved_levels/"
#const SAVE_FILE = ".file"

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
onready var level = $"%level"
onready var wall = $"%wall"
onready var playarea = $"%playarea"
onready var inventory = $level/inventory
onready var other_ui = $"%other_ui"
onready var mobile_controls = $level/mobile_controls
onready var tasks_ui = $level/tasks_ui

var timer = null
var x = 1

# Called when the node enters the scene tree for the first time.
func _ready():
	wall.owner = level
	playarea.owner = level
	inventory.owner = level
	tasks_ui.owner = level
	mobile_controls.owner = level
	playarea.set_width(Global.w * 2)
	playarea.set_depth(Global.d * 2)
	playarea.set_material(Global.grid)
	wall.set_material(Global.grid_out)
	
	var dir = Directory.new()
	if not dir.dir_exists( SAVE_FOLDER ):
		dir.make_dir_recursive( SAVE_FOLDER )


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
func on_timeout_complete():
	#print(x)
	#x += 1
	pass
