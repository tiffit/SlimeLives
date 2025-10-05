extends Node

var cross_fade_player_scene: PackedScene = preload("res://audio/CrossFadePlayer.tscn")

var player: CrossFadePlayer
var pitch_dest: float = -1
var pitch_dest_delta = 0

func _ready():
	process_mode = Node.PROCESS_MODE_ALWAYS
	player = cross_fade_player_scene.instantiate()
	add_child(player)
	player.get_node("Player1").bus = &"music"
	player.get_node("Player2").bus = &"music"

func play_music(song: AudioStream):
	if song != player.stream:
		player.stream = song
		if player.stream:
			player.force_play()
			
func _process(delta: float) -> void:
	if pitch_dest != -1:
		if abs(pitch_dest - player.pitch) < abs(pitch_dest_delta):
			player.pitch = pitch_dest
			pitch_dest = -1
		else:
			player.pitch += pitch_dest_delta*delta

func go_to_pitch(value: float, time: float):
	if time == 0:
		pitch_dest = -1
		player.pitch = value
		return
	pitch_dest = value
	pitch_dest_delta = (pitch_dest - player.pitch) / time
