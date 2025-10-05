class_name Door extends StaticBody2D
@onready var animation_player: AnimationPlayer = $AnimationPlayer

@export var activation_id: int = 0
var activated: bool = false

func activate(id: int):
	if id == activation_id and not activated:
		activated = true
		process_mode = Node.PROCESS_MODE_DISABLED
		modulate = Color(1.0, 1.0, 1.0, 0.196)


func deactivate(id: int):
	if id == activation_id and activated:
		activated = false
		process_mode = Node.PROCESS_MODE_INHERIT
		modulate = Color(1.0, 1.0, 1.0, 1.0)
