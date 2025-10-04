class_name Checkpoint extends Spawnable

var level: Level = null

func _ready() -> void:
	level = get_parent()

func _on_player_entered(body: Node2D) -> void:
	if level and body is Character:
		level.current_spawn = self
