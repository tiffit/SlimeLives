extends Node2D

@export var level_select_button_scene: PackedScene
@export var level_info: LevelInfo
@export var game_main_scene: PackedScene
@export var blank_collectible: Texture2D

func _ready() -> void:
	%Background.texture = Globals.menu_background
	
	var completed: Array[String] = SaveHelper.data.completed
	var collected: Array[String] = SaveHelper.data.collected
	
	var previous_completed: bool = false
	for level_scene in level_info.levels:
		var level: Level = level_scene.instantiate()
		var btn: Button = level_select_button_scene.instantiate()
		if level.level_region == Level.LevelRegion.TWISTED_FOREST:
			%ForestLevels.add_child(btn)
		elif level.level_region == Level.LevelRegion.POISON_SWAMP:
			%SwampLevels.add_child(btn)
		elif level.level_region == Level.LevelRegion.WITCH_TOWER:
			%TowerLevels.add_child(btn)
		
		var level_completed: bool = level.level_name in completed
		if level_completed or previous_completed:
			btn.text = level.level_name
			previous_completed = level_completed
			btn.pressed.connect(func(): load_level(level_info.levels.find(level_scene)))
			if !(level.level_name in collected):
				btn.get_node("Collectible").texture = blank_collectible
		else:
			btn.text = "???"
			previous_completed = false
			btn.disabled = true
			btn.get_node("Collectible").texture = null
		level.queue_free()
		
func load_level(index: int):
	Globals.next_level_index = index
	get_tree().change_scene_to_packed(game_main_scene)
