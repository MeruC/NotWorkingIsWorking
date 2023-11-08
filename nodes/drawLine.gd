extends Node2D

class Line:

	var id
	var color
	var thickness
	var a = Vector3()
	var b = Vector3()

var Lines
var Camera_Node

func _ready():

	Camera_Node = get_viewport().get_camera()

	Lines = []
	set_process(true)

func _draw():

	for line in Lines:

		draw_line(line.a, line.b, line.color, line.thickness)

func _process(delta):

	update()

func Draw_Line3D(id, vector_a, vector_b, color, thickness):

	for line in Lines:
		if line.id == id:
			line.color = color
			line.a = Camera_Node.unproject_position(vector_a)
			line.b = Camera_Node.unproject_position(vector_b)
			line.thickness = thickness
			return

	var new_line = Line.new()
	new_line.id = id
	new_line.color = color
	new_line.a = Camera_Node.unproject_position(vector_a)
	new_line.b = Camera_Node.unproject_position(vector_b)
	new_line.thickness = thickness

	Lines.append(new_line)

func Remove_Line(id):

		var i = 0
		var found = false
		for line in Lines:

			if line.id == id:
				found = true
				break
			i += 1

		if found:

			Lines.remove(i)
