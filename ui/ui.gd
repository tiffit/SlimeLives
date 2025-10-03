extends Control

@onready var game_main: Node2D = $"../.."
@onready var options_menu: CanvasLayer = $"../../OptionsMenu"
@onready var heart_icon: TextureRect = $PanelContainer/MarginContainer/HBoxContainer/HeartIcon

func _on_button_pressed() -> void:
	options_menu.options_toggle()

func show_level_name(level_name: String):
	$LevelName.text = level_name
	$LevelName.modulate.a = 0
	
	var tween = create_tween()
	tween.tween_property($LevelName, "modulate", Color8(255, 255, 255, 255), 1)
	tween.tween_interval(2)
	tween.tween_property($LevelName, "modulate", Color8(255, 255, 255, 0), 2)


func _on_game_main_i_died() -> void:
	heart_icon.play_fall()
