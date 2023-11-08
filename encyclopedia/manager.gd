extends Control

export (PackedScene) var entry_scene
export (NodePath) onready var item_container = get_node(item_container) as VBoxContainer
export (NodePath) onready var content_holder = get_node(content_holder) as Label
export (NodePath) onready var term_label = get_node(term_label) as Label

var previous_scene = "res://scenes/main_screen/main_screen.tscn"
var json_file = "res://encyclopedia/json/encyclopedia.json"
var json_data

func _ready():
	TransitionNode.animation_player.play("in")
	#yield(get_tree().create_timer(0.5), "timeout")
	list_items()
	pass
	
func list_items():
	# For getting data in a JSON file and putting it in the json_data variable as dictionary
	var file = File.new()
	if file.open(json_file, File.READ) == OK:
		var json_content = file.get_as_text()
		file.close()
		var json_result = JSON.parse(json_content)
		if json_result.error == OK:
			json_data = json_result.result
		else:
			print("JSON parsing error:", json_result.error_string)
	else:
		print("Failed to open JSON file.")
	##
	
	# To display all items in list
	var i = 0
	for item in json_data:
		var new_entry = entry_scene.instance()
		new_entry.find_node("word").text = json_data[i]["term"]
		new_entry.content_holder = content_holder
		new_entry.term_label = term_label
		new_entry.definition = json_data[i]["definition"]
		#new_entry.image = json_data[i]["image"]
		i += 1
		item_container.add_child(new_entry)
	##


func _on_search_text_changed(new_text):
	for item in item_container.get_children():
		item.queue_free()
	list_items()
	
	if new_text != "":
		for item in item_container.get_children():
			var word = item.find_node("word").text.to_upper()
			new_text = new_text.to_upper()
			if word.begins_with(new_text):
				pass
			else:
				item.visible = false
	else:
		for item in item_container.get_children():
			item.queue_free()
		list_items()
	##


func _on_back_pressed():
	Load.load_scene(self,previous_scene)
