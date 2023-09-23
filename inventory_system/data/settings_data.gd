class_name Settings_Data extends Resource

export( bool ) var fullscreen = true
export( float ) var scale = 1
export( int ) var gold_coins = 1000
export (String) var player_name = "Billy"
export (String) var gender = "male"
export (String) var rank = "1"
export (String) var account_status
export (int) var net1_skills = 0
export (int) var net2_skills = 0

# Set the data from a Dictionary.
func set_data( data ):
	fullscreen = data.fullscreen
	scale = data.scale
	gold_coins = data.gold_coins
	player_name = data.player_name
	gender = data.gender
	rank = data.rank
	account_status = data.account_status
	net1_skills = data.net1_skills
	net2_skills = data.net2_skills
	emit_changed()

func player_data(data):
	player_name = data
	gender = data
	rank = data
	account_status = data
	net1_skills = data
	net2_skills = data
	emit_changed()

# Pack the data in a Dictionary.
func get_data():
	return {
		"fullscreen": fullscreen,
		"scale": scale,
		"gold_coins": gold_coins,
		"player_name": player_name,
		"gender": gender,
		"rank": rank,
		"account_status": account_status,
		"net1_skills": net1_skills,
		"net2_skills": net2_skills
	}
