extends Node2D

#export( NodePath ) onready var VoiceGen = get_node( VoiceGen ) as AudioStreamPlayer
export( NodePath ) onready var dialog = get_node( dialog ) as Label

var json_file = "res://offline_levels/json/level6_script.json"
var json_data = []
var textSpeed = 1
var total_character = 0
var click = 0
var size = 0
var game_scene = "res://offline_levels/level6/level6.tscn"
var touch = true

func _ready():
	Pixelizer.set_visible(false)
	#VoiceGen.pitch_scale = 1.5
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
	update_dialog()
	
func _process(_delta):
	if $dialog.visible_characters < total_character:
		 $dialog.visible_characters += textSpeed
		
	if Input.is_action_just_pressed("ui_accept"):
		click +=1 
		$dialog.visible_characters = total_character
		if click == 2:
			click = 0
			size += 1
			update_dialog()

			
func _input(event):
	if touch and event is InputEventScreenTouch and event.pressed:
		click += 1
		$dialog.visible_characters = total_character
		if click == 2:
			click = 0
			size += 1
			update_dialog()

func update_dialog():
	if size < json_data.size():
		var title = json_data[size]["title"]
		var content = json_data[size]["content"]
		var card_title = json_data[size]["png"]
		$dialog.text = content
		$card_title.text = card_title
		total_character = content.length()
		
		$dialog.visible_characters = 0
		$title.text = title
		
		#VoiceGen.read(dialog.text)
		
		if size == 3:
			$card_wireless.visible = true
			$card_content.visible = true
			$card_content.text = content
			$AnimationPlayer.play("card_flip")
		if size == 4:
			$card_wireless/TextureRect.texture = load("res://resources/offline_mode_Asset/level_6/"+card_title+".png")
			$AnimationPlayer.play("card_flip")
			$card_content.text = content
		if size == 5:
			$card_wireless/TextureRect.texture = load("res://resources/offline_mode_Asset/level_6/"+card_title+".png")
			$AnimationPlayer.play("card_flip")
			$card_content.text = content
		if size == 6:
			$card_wireless/TextureRect.texture = load("res://resources/offline_mode_Asset/level_6/"+card_title+".png")
			$AnimationPlayer.play("card_flip")
			$card_content.text = content
		if size == 7:
			$AnimationPlayer.play("RESET")
			$card_wireless.visible = false
			$card_title.visible = false
			$card_content.visible = false
		if size == 8:
			$AnimationPlayer.play("discussion_anim")
		if size == 9:
			$image_holder.visible = false
		if size == 10:
			$AnimationPlayer.play("discussion_anim")
			$image_holder.texture = load("res://resources/offline_mode_Asset/level_6/"+card_title+".png")
		if size == 11:
			$image_holder.visible = false
		if size == 12:
			$AnimationPlayer.play("discussion_anim")
			$image_holder.texture = load("res://resources/offline_mode_Asset/level_6/"+card_title+".png")
		if size == 13:
			$image_holder.visible = false
		if size == 14:
			$AnimationPlayer.play("discussion_anim")
			$image_holder.texture = load("res://resources/offline_mode_Asset/level_6/"+card_title+".png")
		if size == 15:
			$image_holder.visible = false
	else:
		Load.load_scene(self,game_scene)
		print("Dialog ended.")
