extends Control

export(NodePath) onready var topology_image = get_node(topology_image) as TextureRect
export(NodePath) onready var number_label = get_node(number_label) as Label
export(NodePath) onready var star_button = get_node(star_button) as Button
export(NodePath) onready var bus_button = get_node(bus_button) as Button
export(NodePath) onready var ring_button = get_node(ring_button) as Button
export(NodePath) onready var mesh_button = get_node(mesh_button) as Button
export(NodePath) onready var hybrid_button = get_node(hybrid_button) as Button
export(NodePath) onready var gameover_popup = get_node(gameover_popup) as Control
export(NodePath) onready var gameover_indicator = get_node(gameover_indicator) as Label
export(NodePath) onready var gameover_score = get_node(gameover_score) as Label
export(NodePath) onready var gameover_next = get_node(gameover_next) as Button

var topologies = [preload("res://resources/offline_mode_Asset/level_7/bus_topology.png"),
					preload("res://resources/offline_mode_Asset/level_7/hybrid_topology.png"),
					preload("res://resources/offline_mode_Asset/level_7/mesh_topology.png"),
					preload("res://resources/offline_mode_Asset/level_7/ring_topology.png"),
					preload("res://resources/offline_mode_Asset/level_7/star_topology.png")]
					
var contents = ["BUS TOPOLOGY", "HYBRID TOPOLOGY", "MESH TOPOLOGY", "RING TOPOLOGY", "STAR TOPOLOGY"]
					
var current_number = 1
var score = 0

func _ready():
	display_image()

func display_image():
	number_label.text = str(current_number)
	var i = rand_range(0,topologies.size())
	topology_image.texture = topologies[i]
	topologies.remove(i)
	topology_image.content = contents[i]
	contents.remove(i)
	current_number += 1

func check_answer(answer):
	if answer == topology_image.content:
		score += 1

	if current_number != 6:
		display_image()
	else:
		display_gameover()

func display_gameover():
	var score_text = ""
	if score > 3:
		gameover_indicator.text = "Level Complete!"
		score_text = "Your Score: " + str(score) + " / 5"
		gameover_score.text = score_text
		gameover_next.disabled = false
	else:
		gameover_indicator.text = "Level Failed"
		score_text = "Your Score: " + str(score) + " / 5"
		gameover_score.text = score_text
		gameover_next.disabled = true
	gameover_popup.visible = true


func _on_star_pressed():
	check_answer(star_button.text.to_upper())


func _on_bus_pressed():
	check_answer(bus_button.text.to_upper())


func _on_ring_pressed():
	check_answer(ring_button.text.to_upper())


func _on_mesh_pressed():
	check_answer(mesh_button.text.to_upper())


func _on_hybrid_pressed():
	check_answer(hybrid_button.text.to_upper())


func _on_retry_pressed():
	get_tree().reload_current_scene()
