class_name OptionsMenu extends CanvasLayer

var should_remove_on_close: bool = false
var hide_main_menu_btn: bool = false
var main_menu_scene: PackedScene = preload("res://ui/main_menu/main_menu.tscn")

func _ready() -> void:
	if hide_main_menu_btn:
		%MainMenuButton.visible = false

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("toggle_options"):
		options_toggle()
		
func options_toggle() -> void:
	visible = !visible
	get_tree().paused = visible
	if not visible and should_remove_on_close:
		queue_free()


func _on_main_menu_button_pressed() -> void:
	get_tree().paused = false
	queue_free()
	get_tree().change_scene_to_packed(main_menu_scene)
