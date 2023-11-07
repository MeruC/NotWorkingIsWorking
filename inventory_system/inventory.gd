extends CanvasLayer

onready var ui_container = $ui_container
onready var crafting_menu = $crafting_menu
onready var craftingbg = $craftingbg
onready var animation_player = $AnimationPlayer


func _ready():
	SignalManager.connect("crimp", self, "_on_crimp")
	
func _on_crimp():
	if crafting_menu.visible == true:
		animation_player.play_backwards("craft")
		yield(animation_player, "animation_finished")
		crafting_menu.visible = false
		craftingbg.visible = false
	else:
		crafting_menu.visible = true
		craftingbg.visible = true
		animation_player.play("craft")

