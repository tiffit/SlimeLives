extends Node

signal on_ready()

var is_ready: bool = false
var data: SaveData = SaveData.new()

func _ready() -> void:
	load_data()
	save_data()
	is_ready = true
	on_ready.emit()

func load_data() -> void:
	if FileAccess.file_exists(save_path()):
		data = ResourceLoader.load(save_path())

func save_data() -> void:
	ResourceSaver.save(data, save_path())

func save_path() -> String:
	return "user://save.tres"
