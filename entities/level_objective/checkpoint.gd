class_name Checkpoint extends Spawnable

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D

var level: Level = null
var already_filled: bool = false

func _ready() -> void:
	animated_sprite_2d.animation = "default"
	level = get_parent()

func _on_player_entered(body: Node2D) -> void:
	if level and body is Character:
		level.current_spawn = self
		if already_filled == false:
			animated_sprite_2d.play("fill")
			already_filled = true
			%SFX.play()
