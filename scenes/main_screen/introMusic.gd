extends AudioStreamPlayer

onready var audio_loop_player = $AudioLoopPlayer

func _on_intro_finished():
	audio_loop_player.play()
