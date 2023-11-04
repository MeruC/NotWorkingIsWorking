extends Button

onready var current_scene = get_tree().get_root().get_child(get_tree().get_root().get_child_count()-1)
var blank_container
var manager

#export(NodePath) onready var blank_container = get_node(blank_container) as GridContainer
#export(NodePath) onready var submit_button = get_node(submit_button) as Button

# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	for node in current_scene.get_children():
		if node.name == "blank_CenterContainer":
			blank_container = node.get_child(0)
		elif node.name == "manager":
			manager = node

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Button_pressed():
	self.disabled = true
	$AudioStreamPlayer.play()
	var x = 0
	for child in blank_container.get_children():
		if child.text == "_":
			child.text = self.text
			manager.enable_submit()
			return
		
			
	
	
