class_name TestDeathTrap extends Entity

var game_main: GameMain

func _ready() -> void:
	game_main = get_node("/root/GameMain")

func _on_player_entered(body: Node2D) -> void:
	if body is Character:
		await body.kill_and_respawn(Character.KillReason.ENTITY)
