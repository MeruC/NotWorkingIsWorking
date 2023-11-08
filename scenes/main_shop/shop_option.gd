extends InnerPanel

export ( NodePath ) onready var price_list = get_node( price_list ) as VBoxContainer
export ( NodePath ) onready var produce_list = get_node( produce_list ) as VBoxContainer
export ( NodePath ) onready var craft_btn = get_node( craft_btn ) as Button
export ( NodePath ) onready var price_lbl = get_node( price_lbl ) as Label
export ( String ) var panel_title
export ( int ) var price
export ( String ) var item_id
export ( int ) var quantity

onready var produce = [{
		"id": item_id, 
		"quantity": quantity
	}]


var recipe_id = "RJ45"

onready var coins = $"%player_coins"


export( Resource ) var settings_data
export( Resource ) var player_data

func _ready():
	SignalManager.connect( "inventory_group_content_changed", self, "_on_inventory_group_changed" )
	set_title(panel_title)
	price_lbl.text = str(price)
	set_info(produce)
	set_craft_button()
	


# Set the price and produce list.
func set_info( produce_items ):
	#price = price_items
	produce = produce_items
	
	
	for item_data in produce_items:
		var produce_node = ResourceManager.get_instance( "item_quantity" )
		produce_list.add_child( produce_node )
		var item = ItemManager.get_item( item_data.id )
		produce_node.set_info( item, item_data.quantity )

# Activate the craft button if the 'crafting' inventories has the needed items
# and the 'player' inventories has enough space for the produced items.
func set_craft_button():
	print(settings_data.gold_coins)
	var can_craft = settings_data.gold_coins >= 50
	craft_btn.disabled = not can_craft
	print(settings_data.has_crimp)
	if item_id == "crimping":
		for N in player_data.inventories["inventory_left"]:
			if player_data.inventories["inventory_left"][N]["id"] == "crimping":
				craft_btn.disabled = true
		for N in player_data.inventories["inventory_right"]:
			if player_data.inventories["inventory_right"][N]["id"] == "crimping":
				craft_btn.disabled = true
	pass

# When crafting, remove the price tiems, adds the produces.
func _on_craft_pressed():
	var current_coins = int(coins.text)
	if current_coins < price:
		return
	coins.text = str(current_coins - price)
	settings_data.gold_coins = int(coins.text)
	InventoryManager.add_items( ItemManager.get_items( produce ), "player" )
	settings_data.has_crimp = true
	craft_btn.disabled = true

# Check to see if it's possible to craft after a change in the player/crafting inventories.
func _on_inventory_group_changed( groups ):
	if groups.has( "player" ) or groups.has( "crafting" ):
		set_craft_button()
