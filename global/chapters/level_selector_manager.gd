extends Spatial
export (Resource) var settings_data 

# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	$level2.disabled = true
	if settings_data.level1 == "complete":
		$level_container/level2.disabled = false


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_level1_pressed():
	Load.load_scene(self, "res://offline_levels/level1/level1_discussion/level1_discussion.tscn")
	$".".queue_free()
