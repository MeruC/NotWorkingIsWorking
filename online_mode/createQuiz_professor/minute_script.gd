extends LineEdit

func _ready():
	# Connect the "text_changed" signal to the "_on_text_changed" method
	connect("text_changed", self, "_on_text_changed")
