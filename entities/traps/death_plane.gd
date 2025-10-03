class_name DeathPlane extends Entity

@onready var area_2d: Area2D = $Area2D

var game_main: GameMain

func _ready() -> void:
	game_main = get_node("/root/GameMain")
	if area_2d:
		area_2d.body_entered.connect(_on_player_entered)
		
func _on_player_entered(body: Node2D) -> void:
	if body is Character:
		await body.kill_and_respawn(Character.KillReason.ENTITY)
