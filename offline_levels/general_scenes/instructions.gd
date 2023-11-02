extends Control

export(NodePath) onready var sprite = get_node(sprite) as Sprite
export(NodePath) onready var level3 = get_node(level3) as Sprite
export(NodePath) onready var level4 = get_node(level4) as Sprite
func _on_tap_pressed():
	self.visible = false
	sprite.visible = false
	level3.visible = false
	level4.visible = false

