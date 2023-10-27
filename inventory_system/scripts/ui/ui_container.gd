extends Control

#export( NodePath ) onready var settings = get_node( settings ) as Control
export( NodePath ) onready var player_inventory = get_node( player_inventory ) as Control
onready var crafting_menu = $"%crafting_menu"

func _input( event ):
	if event.is_action_pressed( "inventory" ):
		player_inventory.visible = not player_inventory.visible
	if event.is_action_pressed( "craft" ):
		crafting_menu.visible = not crafting_menu.visible
		crafting_menu.raise()

func _on_settings_pressed():
	#settings.visible = ! settings.visible
	#settings.raise()
	pass
