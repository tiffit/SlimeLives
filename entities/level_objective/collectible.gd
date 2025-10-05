class_name Collectible extends Entity

@onready var game_main: GameMain = $"/root/GameMain"
@onready var animation_player: AnimationPlayer = $AnimationPlayer

func _on_player_entered(body: Node2D) -> void:
	if get_parent() is Level:
		var level_name: String = get_parent().level_name
		if not (level_name in SaveHelper.data.collected):
			SaveHelper.data.collected.append(level_name)
			SaveHelper.save_data()
	
	animation_player.play("spin")
	await animation_player.animation_finished
	queue_free()
