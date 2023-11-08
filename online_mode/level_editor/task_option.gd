extends Control

onready var level = $"%level"
onready var menu_animations = $"%MenuAnimations"

onready var task_set_conn = $tasks/ScrollContainer/tasks_vbox/taskSetConn/task_cb
onready var task_test_conn = $tasks/ScrollContainer/tasks_vbox/taskTestConn/task_cb
onready var task_conf_ip = $tasks/ScrollContainer/tasks_vbox/taskConfIP/task_cb
onready var task_conf_pc = $tasks/ScrollContainer/tasks_vbox/taskConfPC/task_cb
onready var task_conf_router = $tasks/ScrollContainer/tasks_vbox/taskConfRouter/task_cb
onready var conf_IP_option = $tasks/ScrollContainer/tasks_vbox/taskConfIP/Label/confIPoption
onready var conf_router_option = $tasks/ScrollContainer/tasks_vbox/taskConfRouter/Label/confRouterPoption


func _on_taskdone_pressed():
	if !task_set_conn.pressed and !task_test_conn.pressed and !task_conf_ip.pressed and !task_conf_pc.pressed and !task_conf_router.pressed:
		ConfirmDialog.mode = "OK Dialog"
		ConfirmDialog._ready()
		ConfirmDialog.set_visible(true)
		ConfirmDialog.confirm_animation.play("intro")
		ConfirmDialog.label.text = "Please select atleast one task!"
		ConfirmDialog.action = "null"
	else:
		level.setConn = task_set_conn.pressed
		level.testConn = task_test_conn.pressed
		level.confIP = task_conf_ip.pressed
		level.confPC = task_conf_pc.pressed
		level.confRouter = task_conf_router.pressed
		level.confIPClass = conf_IP_option.text
		level.confRouterClass = conf_router_option.text
		menu_animations.play_backwards("task_option")
		yield(menu_animations, "animation_finished")
		self.visible = false

func _on_set_task_pressed():
	self.visible = true
	menu_animations.play("task_option")
