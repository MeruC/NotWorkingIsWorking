extends CheckBox

onready var task_6 = $"%taskConfPC"
onready var task_cb = $"../../taskConfPC/task_cb"

func _on_task_cb_pressed():
	task_6.visible = pressed
	if !pressed:
		task_cb.pressed = false
