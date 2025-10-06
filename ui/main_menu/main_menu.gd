extends Node2D

@export var options_menu_scene: PackedScene
@export var game_main_scene: PackedScene
@export var level_select_scene: PackedScene
@export var level_info: LevelInfo
@export var click_sound: AudioStream

var next_level_index: int = 0
var next_level_region: Level.LevelRegion = Level.LevelRegion.TWISTED_FOREST
var seen_intro_comic: bool

func _ready() -> void:
	if(SaveHelper.is_ready):
		load_save_data()
	else:
		SaveHelper.on_ready.connect(load_save_data)

func load_save_data():
	var data: SaveData = SaveHelper.data
	if !data.completed.is_empty():
		for level_index in range(level_info.levels.size()):
			var level: Level = level_info.levels[level_index].instantiate()
			var level_region: Level.LevelRegion = level.level_region
			var level_name: String = level.level_name
			level.queue_free()
			if !(level_name in data.completed):
				next_level_index = level_index
				next_level_region = level_region
				break
	
	if next_level_index > 0:
		%PlayBtn.text = "Continue"
		Globals.next_level_index = next_level_index
	%Background.texture = level_info.region_bgs[next_level_region]
	MusicController.play_music(level_info.region_music[next_level_region])
	seen_intro_comic = data.comic_seen

func _on_play_btn_pressed() -> void:
	if !seen_intro_comic:
		get_tree().change_scene_to_file("res://ui/comic/Comic.tscn")
		return
	get_tree().change_scene_to_packed(game_main_scene)

func _on_lvl_select_btn_pressed() -> void:
	Globals.menu_background = %Background.texture
	get_tree().change_scene_to_packed(level_select_scene)

func _on_options_btn_pressed() -> void:
	var options: OptionsMenu = options_menu_scene.instantiate()
	options.should_remove_on_close = true
	options.hide_main_menu_btn = true
	add_child(options)

func _on_reset_save_data_btn_pressed() -> void:
	SaveHelper.data = SaveData.new()
	SaveHelper.save_data()
	Globals.next_level_index = -1
	MusicController.play_one_shot(click_sound)
	get_tree().change_scene_to_file("res://ui/main_menu/main_menu.tscn")
