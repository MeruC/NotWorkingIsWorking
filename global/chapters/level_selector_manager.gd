extends Spatial
export (Resource) var settings_data 


func _ready():
	Pixelizer.set_visible(false)
	
func _on_level1_pressed():
	Load.load_scene(self, "res://offline_levels/level1/level1_discussion/level1_discussion.tscn")


func _on_level2_pressed():
	Load.load_scene(self, "res://offline_levels/level2/level2_discussion/level2_discussion.tscn")

func _on_level3_pressed():
	Load.load_scene(self, "res://offline_levels/level3/level3_discussion.tscn")

func _on_level4_pressed():
	Load.load_scene(self, "res://offline_levels/level4/level4_discussion/level4_discussion.tscn")


func _on_level5_pressed():
	Load.load_scene(self,"res://offline_levels/level5/level5_discussion/level5_discussion.tscn")

func _on_level6_pressed():
	Load.load_scene(self,"res://offline_levels/level6/level6_discussion.tscn")
	
func _on_level7_pressed():
	Load.load_scene(self,"res://offline_levels/level7/level7_discussion.tscn")

func _on_level8_pressed():
	Load.load_scene(self,"res://offline_levels/level8/level8_discussion.tscn")

func _on_level9_pressed():
	pass # Replace with function body.


func _on_back_pressed():
	Load.load_scene(self, "res://scenes/main_screen/main_screen.tscn")
	
