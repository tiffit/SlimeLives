class_name EndPoint extends Entity


var game_main: GameMain

func _ready() -> void:
	game_main = get_node("/root/GameMain")
	

func _on_player_entered(body: Node2D) -> void:
	if body is Character:
		body.process_mode = PROCESS_MODE_DISABLED
		var tweener: MethodTweener = game_main.current_level.play_circle(true)
		if tweener:
			await tweener.finished
		game_main.load_next_level()
