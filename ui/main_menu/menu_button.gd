extends Button

@export var click_sound: AudioStream

func _on_pressed() -> void:
	if click_sound:
		MusicController.play_one_shot(click_sound)
