extends Node

# Inventory
signal inventory_opened( inventory )
signal inventory_closed( inventory )
signal inventory_ready( inventory )
signal item_dropped( item )
signal upgrade_item()
signal inventory_group_content_changed( groups )
signal cooldown_started( usable )

# Interactables
signal crafting_opened( crafting_list_id )
signal crafting_out_of_range()

# UI
signal ui_scale_changed( value )

# Player
signal player_life_changed( life, max_life )
signal cable_used()
signal cable_done()
signal cable_ui()
signal cable_back()
# listen to
signal heal_player( health_points )

# Save Manager
signal saving_game()

signal pc_opened()
signal pc_closed()
signal router_open()
signal router_close()

# Confirm / OK Dialog
signal confirm()
signal cancel()
signal ok()


signal showcable()

signal crimp()
signal craft()
signal craft_end()
