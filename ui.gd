extends Control

@onready var game_main: Node2D = $"../.."
@onready var options_menu: CanvasLayer = $"../../OptionsMenu"

func _on_button_pressed() -> void:
	options_menu.options_toggle()
