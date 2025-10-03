extends TextureRect
@onready var animation_player: AnimationPlayer = $AnimationPlayer

func play_fall() -> void:
	animation_player.play("fall")

func play_swing() -> void:
	animation_player.play("RESET")
	await animation_player.animation_finished
	animation_player.play("swing")
