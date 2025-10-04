class_name Collectible extends Entity

@onready var game_main: GameMain = $"/root/GameMain"

func _on_player_entered(body: Node2D) -> void:
	queue_free()
