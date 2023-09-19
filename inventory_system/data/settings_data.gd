class_name Settings_Data extends Resource

export( bool ) var fullscreen = true
export( float ) var scale = 1
export( int ) var gold_coins = 1000

# Set the data from a Dictionary.
func set_data( data ):
	fullscreen = data.fullscreen
	scale = data.scale
	gold_coins = data.gold_coins
	emit_changed()

# Pack the data in a Dictionary.
func get_data():
	return {
		"fullscreen": fullscreen,
		"scale": scale,
		"gold_coins": gold_coins
	}
