extends Spatial

const SAVE_FOLDER = "user://saved_levels/"
#const SAVE_FILE = ".file"

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
onready var level = $"%level"
onready var wall = $"%wall"
onready var playarea = $"%playarea"
onready var floormesh = $level/floor
onready var inventory = $level/inventory
onready var other_ui = $"%other_ui"
onready var mobile_controls = $level/mobile_controls
onready var tasks_ui = $level/tasks_ui
onready var popups = $level/popups
onready var item__select__menu = $"%Item_Select_Menu"
onready var infopanel = $"%infopanel"

var gray = preload("res://resources/Materials/grid.tres")
var gray_out = preload("res://resources/Materials/grid_out.tres")
var blue = preload("res://resources/Materials/blue_grid.tres")
var blue_out = preload("res://resources/Materials/blue_grid_out.tres")
var orange = preload("res://resources/Materials/orange_grid.tres")
var orange_out = preload("res://resources/Materials/orange_grid_out.tres")

onready var name_le = $"%nameLE"
onready var timerChoice = $"%timer"
onready var w = $"%w"
onready var d = $"%d"
onready var color_2 = $"%color2"

onready var menu_animations = $"%MenuAnimations"

var grid
var grid_out

var timer = null
var x = 1

func _entered():
	Global.can_place = false
func _exited():
	Global.can_place = true

# Called when the node enters the scene tree for the first time.
func _ready():
	name_le.text = level.level_name
	Global.editor_mode = "menu"
	Global.on_save_load = true
	grid = Global.grid
	grid_out = Global.grid_out
	wall.owner = level
	popups.owner = level
	playarea.owner = level
	inventory.owner = level
	tasks_ui.owner = level
	mobile_controls.owner = level
	playarea.set_width(Global.w * 2)
	playarea.set_depth(Global.d * 2)
	w.value = Global.w
	d.value = Global.d
	playarea.set_material(Global.grid)
	floormesh.set_material(Global.grid)
	wall.set_material(Global.grid_out)
	color_2.text = ("Color: " + Global.color)
	var dir = Directory.new()
	if not dir.dir_exists( SAVE_FOLDER ):
		dir.make_dir_recursive( SAVE_FOLDER )
		
	item__select__menu.get_node("Item_Select").ready()
	Global._scene_IN()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	#print(level.level_name)
	pass
	
func on_timeout_complete():
	#print(x)
	#x += 1
	pass


func _on_Virtual_joystick_gui_input():
	pass # Replace with function body.

var last_mode = "place"

func _on_info_pressed():
	last_mode = Global.editor_mode
	Global.editor_mode = "menu"
	infopanel.set_visible(true)
	Global.on_save_load = true
	menu_animations.play_backwards("info")
	name_le.text = level.level_name

onready var description = $"%description"

func _on_done_pressed():
	Global.editor_mode = last_mode
	menu_animations.play("info")
	yield(menu_animations, "animation_finished")
	infopanel.set_visible(false)
	playarea.set_width(int(w.value)* 2)
	playarea.set_depth(int(d.value) * 2)
	playarea.set_material(grid)
	floormesh.set_material(grid)
	wall.set_material(grid_out)
	level.level_name = name_le.text
	level.level_desc = description.get_text()
	#print(level.level_desc)
	Global.on_save_load = false
	


func _on_gray_pressed():
	grid = gray
	grid_out = gray_out
	color_2.text = ("Color: Gray")
	

func _on_blue_pressed():
	grid = blue
	grid_out = blue_out
	color_2.text = ("Color: Blue")

func _on_orange_pressed():
	grid = orange
	grid_out = orange_out
	color_2.text = ("Color: Orange")

onready var desc = $UI/infopanel/Control/desc

func _on_description_pressed():
	desc.set_visible(true)
	menu_animations.play("desc")
	description.text = level.level_desc
	
func _on_descdone_pressed():
	menu_animations.play_backwards("desc")
	yield(menu_animations, "animation_finished")
	desc.set_visible(false)


func _on_mainmenu_pressed():
	ConfirmDialog.set_visible(true)
	ConfirmDialog.confirm_animation.play("intro")
	ConfirmDialog.label.text = "Return to Main Menu?"
	ConfirmDialog.action = "main_menu"


func _on_set_task_pressed():
	pass # Replace with function body.
