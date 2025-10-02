extends CanvasLayer

@onready var game_main: Node2D = $".."


func _process(delta: float) -> void:
	if Input.is_action_just_pressed("toggle_options"):
		options_toggle()
		
func options_toggle() -> void:
	get_tree().paused = not get_tree().paused
	visible = not visible
