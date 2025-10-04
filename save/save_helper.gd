extends Node

var data: SaveData = SaveData.new()

func _ready() -> void:
	load_data()
	save_data()

func load_data() -> void:
	if FileAccess.file_exists(save_path()):
		ResourceLoader.load(save_path())

func save_data() -> void:
	ResourceSaver.save(data, save_path())

func save_path() -> String:
	return "user://save.tres"
