extends Node

var cross_fade_player_scene: PackedScene = preload("res://audio/CrossFadePlayer.tscn")

var player: CrossFadePlayer

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
