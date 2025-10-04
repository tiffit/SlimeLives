extends Control

@onready var game_main: Node2D = $"../.."
@onready var options_menu: CanvasLayer = $"../../OptionsMenu"
@onready var heart_icon: TextureRect = $PanelContainer/MarginContainer/HBoxContainer/HeartIcon

var level: Level = null

func _ready() -> void:
	Globals.find_my_level.connect(on_level_change)

func on_level_change(level: Level):
	self.level = level

func _on_button_pressed() -> void:
	options_menu.options_toggle()

func _process(delta: float) -> void:
	if level:
		%LivesCount.text = "x%d" % [level.lives]

func show_level_name(level_name: String):
	$LevelName.text = level_name
	$LevelName.modulate.a = 0
	
	var tween = create_tween()
	tween.tween_property($LevelName, "modulate", Color8(255, 255, 255, 255), 1)
	tween.tween_interval(2)
	tween.tween_property($LevelName, "modulate", Color8(255, 255, 255, 0), 2)

func _on_game_main_i_died() -> void:
	heart_icon.play_fall()
