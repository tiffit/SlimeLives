class_name OptionsMenu extends CanvasLayer

var should_remove_on_close: bool = false

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("toggle_options"):
		options_toggle()
		
func options_toggle() -> void:
	visible = !visible
	get_tree().paused = visible
	if not visible and should_remove_on_close:
		queue_free()
