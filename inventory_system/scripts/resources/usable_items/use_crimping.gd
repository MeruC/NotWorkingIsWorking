class_name Use_Crimping extends Item_Usable

var cable_type

func _init( data, parent_item ).( data, parent_item ):
	#SignalManager.connect( "player_life_changed", self, "_on_player_life_changed")
	on_use_text = "Cable Type: %s"
	can_always_use = true

# Set the healing amount.
func set_data( data ):
	#cable_type = data.cable_type
	.set_data( data )

# Show the healing amount.
func get_use_text():
	return on_use_text % cable_type

# The item is usable if the player is missing life points.
#func _on_player_life_changed( life, max_life ):
#	can_use = life < max_life

# Apply the healing.
func execute():
	#Global.player._on_cable_used( cable_type )
	print("Place")




