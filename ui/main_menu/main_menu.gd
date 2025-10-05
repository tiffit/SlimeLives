extends Node2D

@export var options_menu_scene: PackedScene
@export var game_main_scene: PackedScene

func _ready() -> void:
	print(SaveHelper.data)

func _on_play_btn_pressed() -> void:
	get_tree().change_scene_to_packed(game_main_scene)

func _on_options_btn_pressed() -> void:
	print("test")
	var options: OptionsMenu = options_menu_scene.instantiate()
	options.should_remove_on_close = true
	add_child(options)
