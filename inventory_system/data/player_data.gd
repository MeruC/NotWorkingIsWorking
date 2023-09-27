class_name Player_Data extends Resource

export( Vector2 ) var global_position = Vector2( 368, 347 )
export( Dictionary ) var inventories
export ( Dictionary ) var player_info

export( int ) var coins
export var player_name: String
export var gender: String
export var rank: String
export var account_status: String
export var email: String
export( int ) var net1_skills
export( int ) var net2_skills


var base_stats = {
	Game_Enums.STAT.STRENGTH: 5,
	Game_Enums.STAT.DEXTERITY: 5,
	Game_Enums.STAT.VITALITY: 5,
	Game_Enums.STAT.INTELLIGENCE: 5,
	Game_Enums.STAT.MOVE_SPEED: 150,
}

var equipment : Equipment
var inventory_left : Inventory
var inventory_right : Inventory
var hotbar : Hotbar
var coin : int

# Initialise the player's inventories.
func _init():
	equipment = Equipment.new().duplicate()
	equipment.name = "Equipment"
	equipment.groups = [ "player", "equipment" ]
	inventory_left = Inventory.new().duplicate()
	inventory_left.name = "Left Pocket"
	inventory_left.size = 10
	inventory_left.groups = [ "player", "crafting" ]
	inventory_right = Inventory.new().duplicate()
	inventory_right.name = "Right Pocket"
	inventory_right.size = 10
	inventory_right.groups = [ "player", "crafting" ]
	hotbar = Hotbar.new().duplicate()
	hotbar.size = 5
	

# Set the data from a Dictionary.
func set_data( data ):
	global_position = data.global_position
	inventories = data.inventories
	coin = data.coins
	player_name = data.player_name
	gender = data.gender
	email = data.email
	emit_changed()
	changed_data()

# Pack the data in a Dictionary.
func get_data():
	inventories.equipment = equipment.get_data()
	inventories.inventory_left = inventory_left.get_data()
	inventories.inventory_right = inventory_right.get_data()
	inventories.hotbar = hotbar.get_data()
	
	return {
		"global_position": global_position,
		"inventories": inventories,
		"coins": coins,
		"player_name": player_name,
		"gender": gender,
		"email": email
	}

func get_stat( stat ):
	var stat_total = 0
	
	if base_stats.has( stat ):
		stat_total += base_stats[ stat ]
	
	for inv in InventoryManager.get_inventories_from_group( "equipment" ):
		stat_total += inv.get_stat( stat )
	
	var stat_data = ResourceManager.stat_info[ stat ]
	if stat_data.has( "affected_by" ):
		for main_stat in stat_data.affected_by:
			stat_total += get_stat( Game_Enums.STAT[ main_stat ] ) * stat_data.affected_by[ main_stat ]
	
	return int( round( stat_total ) )

func get_coins():
	return coins

func changed_data():
	if inventories.size() > 0:
		equipment.set_data( inventories.equipment )
		inventory_left.set_data( inventories.inventory_left )
		inventory_right.set_data( inventories.inventory_right )
		hotbar.set_data( inventories.hotbar )
		




