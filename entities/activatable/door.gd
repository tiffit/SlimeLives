class_name Door extends StaticBody2D

@export var activation_id: int = 0
var activated: bool = false

func activate(id: int):
	if id == activation_id and not activated:
		activated = true
		process_mode = Node.PROCESS_MODE_DISABLED

func deactivate(id: int):
	if id == activation_id and activated:
		activated = false
		process_mode = Node.PROCESS_MODE_INHERIT
