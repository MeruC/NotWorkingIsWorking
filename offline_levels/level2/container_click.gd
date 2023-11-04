extends Button

onready var current_scene = get_tree().get_root().get_child(get_tree().get_root().get_child_count()-1)
var letter_container

var letter 
#export(NodePath) onready var letter_container = get_node(letter_container) as GridContainer 

# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	for node in current_scene.get_children():
		if node.name == "letter_CenterContainer":
			letter_container = node.get_child(0)


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_blank1_pressed():
	letter = self.text
	$AudioStreamPlayer.play()
	self.text = "_"
	for child in letter_container.get_children():
		if child.text == letter:
			if child.disabled == true:
				child.disabled = false
				return
			
