extends Spatial
export (Resource) var settings_data 


func _ready():
	$level2.disabled = true
	$level3.disabled = true
	$level4.disabled = true
	if settings_data.level1 == "complete":
		$level2.disabled = false
	elif settings_data.level2 == "complete":
		$level3.disabled = false
	elif settings_data.level3 == "complete":
		$level4.disabled = false
	


func _on_level1_pressed():
	Load.load_scene(self, "res://offline_levels/level1/level1_discussion/level1_discussion.tscn")


func _on_level2_pressed():
	Load.load_scene(self, "res://offline_levels/level2/level2_discussion/level2_discussion.tscn")

func _on_level3_pressed():
	Load.load_scene(self, "res://offline_levels/level3/level3_discussion.tscn")

func _on_level4_pressed():
	Load.load_scene(self, "res://offline_levels/level4/level4_discussion/level4_discussion.tscn")
