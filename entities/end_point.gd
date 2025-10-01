class_name EndPoint extends Entity


func _on_player_entered(body: Node2D) -> void:
	if body is Character:
		print("win")
