extends OptionButton

onready var label = $"../../../taskConfPC/Label"

func _ready():
	_add_items()

func _add_items():
	add_item("Class A")
	add_item("Class B")
	add_item("Class C")


func _on_confIPoption_item_selected(index):
	match (text):
		"Class A":
			print("A")
			label.text = "- Open each PC and configure their IP addresses using Class A IP addresses.\n- Configure the Default Gateway of each PC based on the IP of the port to which it is connected."
		"Class B":
			print("B")
			label.text = "- Open each PC and configure their IP addresses using Class B IP addresses.\n- Configure the Default Gateway of each PC based on the IP of the port to which it is connected."
		"Class C":
			print("C")
			label.text = "- Open each PC and configure their IP addresses using Class C IP addresses.\n- Configure the Default Gateway of each PC based on the IP of the port to which it is connected."
