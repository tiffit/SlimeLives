class_name CrossFadePlayer extends Node

@export var stream: AudioStream
@export_range(0, 1) var fade_percent: float = 0.1

var playing: bool = false
var flipped: bool = false

func _ready() -> void:
	$Player1.stream = stream
	$Player2.stream = stream

func _process(delta: float) -> void:
	if get_progress() > (1-fade_percent):
		var fade_progress = (get_progress() - (1-fade_percent)) / fade_percent
		get_active_player().volume_linear = 1 - fade_progress
		if !get_alt_player().playing:
			get_alt_player().play()
		get_alt_player().volume_linear = fade_progress
	if playing and !get_active_player().playing:
		flipped = !flipped

func get_active_player() -> AudioStreamPlayer:
	return $Player1 if !flipped else $Player2
	
func get_alt_player() -> AudioStreamPlayer:
	return $Player1 if flipped else $Player2

func get_progress():
	var pos: float = get_active_player().get_playback_position()
	return pos / stream.get_length()

func play():
	if playing:
		return
	playing = true
	$Player1.play()
	$Player1.volume_linear = 1
	$Player2.volume_linear = 0

func stop():
	if !playing:
		return
	playing = false
	$Player1.stop()
	$Player2.stop()
