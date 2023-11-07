extends Control

export( NodePath ) onready var objects_btn = get_node(objects_btn) as Button 
export( NodePath ) onready var current = get_node(current) as Label
export( NodePath ) onready var objects_menu = get_node(objects_menu) as CanvasLayer
onready var object_cursor = get_node("/root/editor/Editor_Object")
onready var item__select__menu = $"%Item_Select_Menu"

func _on_objects_pressed():
	Global.editor_mode = "menu"
	objects_menu.set_visible(true)
	item__select__menu._intro()
	
func _process(delta):
	current.text = object_cursor.current_item_name
