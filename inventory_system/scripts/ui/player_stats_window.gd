extends PanelContainer

export( NodePath ) onready var lbl_coin = get_node( lbl_coin ) as Label

export( Resource ) var settings_data

func _ready():
	settings_data.connect( "changed", self, "_on_data_changed" )
	lbl_coin.text = str( settings_data.gold_coins )

func _on_data_changed():
	lbl_coin.text = str( settings_data.gold_coins )
