class_name EndPoint extends Entity

@export var capture_sound: AudioStream
var game_main: GameMain

func _ready() -> void:
	game_main = get_node("/root/GameMain")
	
func _process(delta: float) -> void:
	if OS.has_feature("editor") and Input.is_action_just_pressed("cheat_finish_level"):
		for child in get_parent().get_children():
			if child is Character:
				child.position = position

func _on_player_entered(body: Node2D) -> void:
	if body is Character:
		body.process_mode = PROCESS_MODE_DISABLED
		MusicController.play_one_shot(capture_sound)
		var tweener: MethodTweener = game_main.current_level.play_circle(true)
		if tweener:
			await tweener.finished
		if game_main.current_level:
			var level_name: String = game_main.current_level.level_name
			if !(level_name in SaveHelper.data.completed):
				SaveHelper.data.completed.append(level_name)
				if game_main.current_level.got_collectible:
					SaveHelper.data.collected.append(level_name)
				SaveHelper.save_data()
		game_main.load_next_level()
