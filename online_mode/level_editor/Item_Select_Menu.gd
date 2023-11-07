extends ColorRect

onready var animation_player = $AnimationPlayer

func _intro():
	animation_player.play("item")

func _outro():
	animation_player.play_backwards("item")
	yield(animation_player, "animation_finished")
	get_parent().visible = false
