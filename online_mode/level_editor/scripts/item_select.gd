extends Button

export(PackedScene) var this_scene
export( Array, String ) var placeOn
export(float) var height
onready var object_cursor = get_node("/root/editor/Editor_Object")
onready var spin = $"%spin"
onready var preview_lbl = $"%previewLbl"

#onready var cursor_sprite = object_cursor.get_node("Sprite")

func _ready():
	connect("gui_input",self,"_item_clicked")
	#_item_clicked(InputEventMouseButton)
	pass # Replace with function body.


func _item_clicked(event):
	if event is InputEventMouseButton:
		#object_cursor.current_item_name = self.text
		object_cursor.current_item = this_scene
		object_cursor.placeOn = placeOn
		object_cursor.height = height * 0.0625
		preview_lbl.text = self.text
		object_cursor.current_item_name = self.text
		for n in spin.get_children():
			spin.remove_child(n)
			n.queue_free()
		var new_item = this_scene.instance() 
		spin.add_child(new_item)
		
