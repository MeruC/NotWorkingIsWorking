extends Node2D

onready var level = $"%level"
var monitors = []

func cable():
	print(monitors)
	update()

func _draw() -> void:
	for N in monitors:
		if N.fe0 != null:
			var I = N.fe0
			draw_line(Vector2(N), Vector2.RIGHT * 300, Color.black, 10.0)
	
