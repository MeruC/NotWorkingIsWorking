class_name Settings_Data extends Resource

export ( String ) var resolution = "1600 x 900"
export( bool ) var fullscreen = false
export( float ) var scale = 1
export( int ) var master_volume = 0
export( int ) var music_volume = -10
export( int ) var sound_volume = -10
export( bool ) var pixelize = true
export( int ) var pixel_size = 4

export( int ) var gold_coins = 1000

export (String) var player_name
export (String) var gender
export (String) var rank
export (String) var account_status
export (String) var level1 = "incomplete"
export (String) var level2 = "incomplete"
export (String) var level3 = "incomplete"
export (String) var level4 = "incomplete"
export (String) var level5 = "incomplete"
export (String) var level6 = "incomplete"
export (String) var level7 = "incomplete"
export (String) var level8 = "incomplete"
export (String) var level9 = "incomplete"
export (String) var email
export (int) var net1_skills = 0
export (int) var net2_skills = 0
export (int) var crowns = 0
export (String) var costume = "male"


# Set the data from a Dictionary.
func set_data( data ):
	#resolution = data.resolution
	fullscreen = data.fullscreen
	scale = data.scale
	gold_coins = data.gold_coins
	master_volume = data.master_volume
	music_volume = data.music_volume
	sound_volume = data.sound_volume
	#pixelize = data.pixelize
	#pixel_size = data.pixel_size
	
	player_name = data.player_name
	
	gender = data.gender
	rank = data.rank
	account_status = data.account_status
	net1_skills = data.net1_skills
	net2_skills = data.net2_skills
	costume = data.costume
	crowns = data.crowns
	level1 = data.level1
	level2 = data.level2
	level3 = data.level3
	level4 = data.level4
	level5 = data.level5
#	level6 = data.level6
#	level7 = data.level7
#	level8 = data.level8
#	level9 = data.level9
	email = data.email
	emit_changed()
# Pack the data in a Dictionary.
func get_data():
	return {
		"resolution": resolution,
		"pixelize": pixelize,
		"pixel_size": pixel_size,
		"fullscreen": fullscreen,
		"scale": scale,
		"gold_coins": gold_coins,
		"master_volume": master_volume,
		"music_volume": music_volume,
		"sound_volume": sound_volume,
		"player_name": player_name,
		"gender": gender,
		"rank": rank,
		"account_status": account_status,
		"net1_skills": net1_skills,
		"net2_skills": net2_skills,
		"costume": costume,
		"crowns": crowns,
		"level1": level1,
		"level2": level2,
		"level3": level3,
		"level4": level4,
		"level5": level5,
		"level6": level6,
		"level7": level7,
		"level8": level8,
		"level9": level9,
		"email": email
	}
