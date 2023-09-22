class_name Settings_Data extends Resource

export( bool ) var fullscreen = true
export( float ) var scale = 1
export( int ) var gold_coins = 1000
export (String) var player_name
export (String) var gender

# Set the data from a Dictionary.
func set_data( data ):
	fullscreen = data.fullscreen
	scale = data.scale
	gold_coins = data.gold_coins
	emit_changed()

func player_data(data):
	player_name = data.player_name
	gender = data.gender
	emit_changed()

# Pack the data in a Dictionary.
func get_data():
	return {
		"fullscreen": fullscreen,
		"scale": scale,
		"gold_coins": gold_coins,
		"player_name": player_name,
		"gender": gender
	}
