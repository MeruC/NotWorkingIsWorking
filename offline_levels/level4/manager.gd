extends Control

var score = 0
var json_file = "res://offline_levels/json/level4_questions.json"
var json_data = ""
var i
var answer

export(NodePath) onready var clue_label = get_node(clue_label) as Label
export(NodePath) onready var score_label = get_node(score_label) as Label
export(NodePath) onready var lan_button = get_node(lan_button) as Button
export(NodePath) onready var man_button = get_node(man_button) as Button
export(NodePath) onready var wan_button = get_node(wan_button) as Button
export(NodePath) onready var button_container = get_node(button_container) as GridContainer

# Explanation popup paths
export(NodePath) onready var explanation_label = get_node(explanation_label) as Label
export(NodePath) onready var logo_rect = get_node(logo_rect) as TextureRect
export(NodePath) onready var popup_control = get_node(popup_control) as Control
##

# Gameover popup paths
export(NodePath) onready var popup_score_label = get_node(popup_score_label) as Label
export(NodePath) onready var game_over_popup = get_node(game_over_popup) as Control
export(NodePath) onready var popup_next_button = get_node(popup_next_button) as Button
export(NodePath) onready var popup_indicator_label = get_node(popup_indicator_label) as Label
##

# Instructions popup paths
export(NodePath) onready var animation_player = get_node(animation_player) as AnimationPlayer
export(NodePath) onready var instructions_popup = get_node(instructions_popup) as Control
export(NodePath) onready var instructions_sprite = get_node(instructions_sprite) as Sprite
##

#players data
export(Resource) var settings_data
##


var home_scene = "res://main_screen/main_screen.tscn"
var next_scene = "res://offline_levels/level5/level5_discussion/level5_discussion.tscn"
var level4_scene = "res://offline_levels/level4/level4.tscn"

# Called when the node enters the scene tree for the first time.
func _ready():
	var file = File.new()
	if file.open(json_file, File.READ) == OK:
		var json_content = file.get_as_text()
		file.close()
		var json_result = JSON.parse(json_content)
		if json_result.error == OK:
			json_data = json_result.result
		else:
			print("JSON parsing error:", json_result.error_string)
	else:
		print("Failed to open JSON file.")
		
	i = 0
	var clue = json_data[i]["question"]
	answer = json_data[i]["answer"]
	clue_label.text = clue
	return answer
	
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_lan_button_pressed():
	if lan_button.text == answer:
		explanation_label.text = json_data[i]["if_correct"]
		logo_rect.texture = load("res://resources/offline_mode_Asset/level_4/correct.png")
		score += 1
		score_label.text = str(score)
	else:
		explanation_label.text = json_data[i]["if_wrong"]
		logo_rect.texture = load("res://resources/offline_mode_Asset/level_4/incorrect.png")
		
	popup_control.visible = true
	
	while i < 4:
		i += 1
		var clue = json_data[i]["question"]
		answer = json_data[i]["answer"]
		clue_label.text = clue
		return answer
	i+=1
	
	clue_label.queue_free()
	button_container.queue_free()
	


func _on_man_button_pressed():
	if man_button.text == answer:
		explanation_label.text = json_data[i]["if_correct"]
		logo_rect.texture = load("res://resources/offline_mode_Asset/level_4/correct.png")
		score += 1
		score_label.text = str(score)
	else:
		explanation_label.text = json_data[i]["if_wrong"]
		logo_rect.texture = load("res://resources/offline_mode_Asset/level_4/incorrect.png")
		
	popup_control.visible = true
	
	while i < 4:
		i += 1
		var clue = json_data[i]["question"]
		answer = json_data[i]["answer"]
		clue_label.text = clue
		return answer
	i+=1
	
	clue_label.queue_free()
	button_container.queue_free()
	


func _on_wan_button_pressed():
	if wan_button.text == answer:
		explanation_label.text = json_data[i]["if_correct"]
		logo_rect.texture = load("res://resources/offline_mode_Asset/level_4/correct.png")
		score += 1
		score_label.text = str(score)
	else:
		explanation_label.text = json_data[i]["if_wrong"]
		logo_rect.texture = load("res://resources/offline_mode_Asset/level_4/incorrect.png")
		
	popup_control.visible = true
	
	while i < 4:
		i += 1
		var clue = json_data[i]["question"]
		answer = json_data[i]["answer"]
		clue_label.text = clue
		return answer
	i+=1
	
	clue_label.queue_free()
	button_container.queue_free()

func _on_tap_pressed():
	instructions_popup.visible = false
	instructions_sprite.visible = false



func _on_home_pressed():
	Load.load_scene(self,home_scene)

func _on_next_pressed():
	Load.load_scene(self,next_scene)

func _on_retry_pressed():
	Load.load_scene(self,level4_scene)



func _on_continue_pressed():
	popup_control.visible = false
	if i == 5:
		if int(score_label.text) >= 4:
			popup_indicator_label.text = "Level Complete!"
			popup_next_button.disabled = false
			score_validation()
		else:
			popup_indicator_label.text = "Level Failed!"
			popup_next_button.disabled = true
	
		popup_score_label.text = "Your Score: " + score_label.text + " / 5"
		game_over_popup.visible = true


func _on_restart_pressed():
	Load.load_scene(self,level4_scene)

func score_validation():
	if settings_data.level4 == "complete":
		pass
	else:
		var current_coins = settings_data.gold_coins
		var new_coins = current_coins+100
		
		var skills = settings_data.net1_skills
		var update_skills = skills+10
		
		settings_data.gold_coins = new_coins
		settings_data.net1_skills = update_skills
		settings_data.level4 = "complete"
		SaveManager.save_game()
