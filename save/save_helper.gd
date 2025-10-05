extends Node

signal on_ready()

var is_ready: bool = false
var data: SaveData = SaveData.new()

func _ready() -> void:
	load_data()
	save_data()
	is_ready = true
	on_ready.emit()
	
	for bus_name in data.volume:
		var bus_index: int = AudioServer.get_bus_index(bus_name)
		var volume: float = data.volume[bus_name]
		AudioServer.set_bus_volume_db(bus_index, linear_to_db(volume))

func load_data() -> void:
	if FileAccess.file_exists(save_path()):
		data = ResourceLoader.load(save_path())

func save_data() -> void:
	ResourceSaver.save(data, save_path())

func save_path() -> String:
	return "user://save.tres"
