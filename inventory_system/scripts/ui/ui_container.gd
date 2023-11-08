extends Control

#export( NodePath ) onready var settings = get_node( settings ) as Control
export( NodePath ) onready var player_inventory = get_node( player_inventory ) as Control
onready var crafting_menu = $"%crafting_menu"
onready var inventorybg = $inventorybg
onready var animation_player = $"../AnimationPlayer"

func _input( event ):
	if get_parent().name != "shop":
		player_inventory.set_pivot_offset(player_inventory.get_size())
	if event.is_action_pressed( "inventory" ):
		if player_inventory.visible == true:
			animation_player.play_backwards("inventory")
			yield(animation_player, "animation_finished")
			player_inventory.visible = false
			inventorybg.visible = false
		else:
			player_inventory.visible = true
			inventorybg.visible = true
			animation_player.play("inventory")
	if event.is_action_pressed( "craft" ):
		crafting_menu.visible = not crafting_menu.visible
		crafting_menu.raise()

func _on_settings_pressed():
	#settings.visible = ! settings.visible
	#settings.raise()
	pass
