class_name EndPoint extends Entity


var game_main: GameMain

func _ready() -> void:
	game_main = get_node("/root/GameMain")
	

func _on_player_entered(body: Node2D) -> void:
	if body is Character:
		game_main.load_next_level()
