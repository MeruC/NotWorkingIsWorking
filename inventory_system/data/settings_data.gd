class_name Settings_Data extends Resource

export ( String ) var resolution = "1600 x 900"
export( bool ) var fullscreen = false
export( float ) var scale = 2
export( int ) var master_volume = 0
export( int ) var music_volume = -10
export( int ) var sound_volume = -10
export( bool ) var pixelize = true
export( int ) var pixel_size = 4

export( int ) var gold_coins = 10000

export (String) var player_name
export (String) var gender
export (String) var account_status
export (int) var level1 = 0
export (int) var level2 = 0
export (int) var level3 = 0
export (int) var level4 = 0
export (int) var level5 = 0
export (int) var level6 = 0
export (int) var level7 = 0
export (int) var level8 = 0
export (int) var level9 = 0
export (int) var net1_skills = 0
export (int) var net2_skills = 0
export (int) var crowns = 0
export (String) var costume = "male"
export (String) var email
export (String) var quick_game = "notplaying"

#costume for boy
export (String) var cict_shirt = "lock"
export (String) var blue_shirt = "lock"
export (String) var formal_attire = "lock"
export (String) var orange_shirt = "lock"
#costume for girl
export (String) var girl_pants = "lock"
export (String) var girl_casual = "lock"


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
	level6 = data.level6
	level7 = data.level7
	level8 = data.level8
	level9 = data.level9
	email = data.email
	quick_game = data.quick_game
	#male
	cict_shirt = data.cict_shirt
	blue_shirt = data.blue_shirt
	formal_attire = data.formal_attire
	orange_shirt = data.orange_shirt
	#female
	girl_pants = data.girl_pants
	girl_casual = data.girl_casual
	
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
		"email": email,
		"cict_shirt": cict_shirt,
		"blue_shirt": blue_shirt,
		"formal_attire": formal_attire,
		"orange_shirt": orange_shirt,
		"girl_pants": girl_pants,
		"girl_casual": girl_casual,
		"quick_game": quick_game
	}
