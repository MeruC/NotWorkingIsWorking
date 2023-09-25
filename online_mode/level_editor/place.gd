extends Control

export( NodePath ) onready var objects_btn = get_node(objects_btn) as Button 
export( NodePath ) onready var current = get_node(current) as Label
export( NodePath ) onready var objects_menu = get_node(objects_menu) as CanvasLayer
onready var object_cursor = get_node("/root/editor/Editor_Object")


func _on_objects_pressed():
	Global.editor_mode = "menu"
	objects_menu.set_visible(true)
	
func _process(delta):
	current.text = "Currently Selected: " + object_cursor.current_item_name
