extends Button

onready var task_pane = $"../task_manager"

func _on_task_button_toggled(button_pressed):
	if button_pressed:
		task_pane.visible = true
	else:
		task_pane.visible = false
