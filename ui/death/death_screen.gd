class_name DeathScreen extends Control

func _ready() -> void:
	MusicController.go_to_pitch(0.5, 3)

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("reset_level") and !is_queued_for_deletion():
		MusicController.go_to_pitch(1, 2)
		queue_free()
