extends Control

export(NodePath) onready var sprite = get_node(sprite) as Sprite

func _on_tap_pressed():
	self.visible = false
	sprite.visible = false
