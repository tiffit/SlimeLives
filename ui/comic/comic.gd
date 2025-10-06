class_name Comic extends Node2D

@export var panels: Array[Texture2D]
@export var song: AudioStream

var index: int = 0

func _ready() -> void:
	show_image()
	SaveHelper.data.comic_seen = true
	SaveHelper.save_data()
	MusicController.play_music(song)
	
func _unhandled_input(event):
	if event is InputEventKey:
		if event.pressed:
			next_panel()
	if event is InputEventMouseButton:
		if event.pressed:
			next_panel()
	
func next_panel():
	index += 1
	if index >= panels.size():
		get_tree().change_scene_to_file("res://game_main.tscn")
	else:
		show_image()
	
func show_image():
	%ComicRect.texture = panels[index]
