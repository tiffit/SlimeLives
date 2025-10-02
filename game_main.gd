class_name GameMain extends Node2D

@export var levels: Array[PackedScene] = [] 
# If set, the level loaded will always be this level
@export var force_level: PackedScene = null

var level_index: int = -1
var current_level: Level = null

func _ready() -> void:
	load_next_level()
	
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("reset_level"):
		level_index -= 1
		load_next_level()

func load_next_level():
	var previous_level_name: String = ""
	if current_level:
		previous_level_name = current_level.level_name
		current_level.queue_free()
	level_index += 1
	
	if level_index >= levels.size():
		level_index = 0
		
	var next_level_scene: PackedScene = force_level if force_level else levels[level_index]
	current_level = next_level_scene.instantiate()
	current_level.name = "Level"
	add_child(current_level)
	if current_level.level_name != previous_level_name:
		$GameUI/UI.show_level_name(current_level.level_name)
