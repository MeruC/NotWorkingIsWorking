extends Control

export(NodePath) onready var sprite = get_node(sprite) as Sprite
export(NodePath) onready var level3 = get_node(level3) as Sprite
export(NodePath) onready var level4 = get_node(level4) as Sprite
export(NodePath) onready var level5 = get_node(level5) as Sprite
export(NodePath) onready var level7 = get_node(level7) as Sprite
export(NodePath) onready var level8 = get_node(level8) as Sprite
func _on_tap_pressed():
	self.visible = false
	sprite.visible = false
	level3.visible = false
	level4.visible = false
	level5.visible = false
	level7.visible = false
	level8.visible = false
