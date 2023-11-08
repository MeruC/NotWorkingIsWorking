extends Spatial
export (Resource) var settings_data 

var net1_levels = ["res://offline_levels/level1/level_1.tscn", "res://offline_levels/level2/level2.tscn",
					"res://offline_levels/level3/level3.tscn", "res://offline_levels/level4/level4.tscn",
					"res://offline_levels/level5/level5.tscn", "res://offline_levels/level6/level6.tscn",
					"res://offline_levels/level7/level7.tscn", "res://offline_levels/level8/level8.tscn"]
var playable = false

func _ready():
	Pixelizer.set_visible(false)
	if settings_data.level1 >= 7 and settings_data.level2 >= 4 and settings_data.level3 >= 4 and settings_data.level4 >= 4 and settings_data.level5 == 7and settings_data.level6 == 5 and settings_data.level7 >= 3 and settings_data.level8 >= 30:
		$shop.disabled = false
	#if settings_data.level1 >= 7 and settings_data.level2 >= 4 and settings_data.level3 >= 4 and settings_data.level4 >= 4 and settings_data.level5 == 7:
	if $level9.visible == true:
		$quick_game.disabled = false
		$reset_time.visible = true
	else:
		$reset_time.visible = false
		$quick_game.disabled = true
		$shop.disabled = true
		
func _process(delta):
	if settings_data.reset_timer <= 10799:
		var reset_timer_float = settings_data.reset_timer
		var reset_timer_int = int(reset_timer_float)
		var total_seconds = 10800
		var remaining_seconds = total_seconds - reset_timer_int
		var remaining_minutes = int(remaining_seconds / 60)
		var remaining_seconds_remainder = remaining_seconds % 60
		$reset_time.text = str(remaining_minutes) + ":" + str(remaining_seconds_remainder)
	else:
		$reset_time.text = ""

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
	Load.load_scene(self,"res://offline_levels/level9/level9.tscn")

func _on_back_pressed():
	Load.load_scene(self, "res://scenes/main_screen/main_screen.tscn")
	
func _on_shop_pressed():
	Load.load_scene(self, "res://scenes/main_shop/main_shop.tscn")


func _on_quick_game_pressed():
	var completed_levels = levels_completed()
	if completed_levels.empty():
		# Handle the case when no levels are completed (e.g., show a message).
		pass
	else:
		var random_level = pick_random_level(completed_levels)
		Load.load_scene(self, random_level)
# To play a random Networking 1 Level

func pick_random_level(completed_levels):
	var number = int(rand_range(0, completed_levels.size()))
	return completed_levels[number]

func levels_completed():
	var completed = []
	if settings_data.level1 >= 7:
		settings_data.quick_game = "isplaying"
		SaveManager.save_game()
		completed.append("res://offline_levels/level1/level_1.tscn")
	if settings_data.level2 >= 4:
		settings_data.quick_game = "isplaying"
		SaveManager.save_game()
		completed.append("res://offline_levels/level2/level2.tscn")
	if settings_data.level3 >= 4:
		settings_data.quick_game = "isplaying"
		SaveManager.save_game()
		completed.append("res://offline_levels/level3/level3.tscn")
	if settings_data.level4 >= 5:
		settings_data.quick_game = "isplaying"
		SaveManager.save_game()	
		completed.append("res://offline_levels/level4/level4.tscn")
	if settings_data.level5 >= 4:
		settings_data.quick_game = "isplaying"
		SaveManager.save_game()
		completed.append("res://offline_levels/level5/level5.tscn")
	if settings_data.level6 >= 5:
		settings_data.quick_game = "isplaying"
		SaveManager.save_game()
		completed.append("res://offline_levels/level6/level6.tscn")
	if settings_data.level7 >= 3:
		settings_data.quick_game = "isplaying"
		SaveManager.save_game()
		completed.append("res://offline_levels/level7/level7.tscn")
	if settings_data.level8 >= 30:
		settings_data.quick_game = "isplaying"
		SaveManager.save_game()
		completed.append("res://offline_levels/level8/level8.tscn")
	if settings_data.level9 >= 30:
		settings_data.quick_game = "isplaying"
		SaveManager.save_game()
		completed.append("res://offline_levels/level9/level9.tscn")
	if settings_data.level10 >= 30:
		settings_data.quick_game = "isplaying"
		SaveManager.save_game()
		completed.append("res://offline_levels/level10/level10.tscn")
	if completed.empty():
		settings_data.quick_game = "notplaying"
		SaveManager.save_game()
		completed.append("res://scenes/quick_game/quickgame.tscn")
	return completed


func _on_level10_pressed():
	Load.load_scene(self,"res://offline_levels/level10/level10.tscn")
