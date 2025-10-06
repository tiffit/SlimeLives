class_name Collectible extends Entity

@onready var game_main: GameMain = $"/root/GameMain"
@onready var animation_player: AnimationPlayer = $AnimationPlayer

func _ready() -> void:
	if get_parent() is Level:
		if get_parent().level_name in SaveHelper.data.collected:
			modulate.a = 0.3

func _on_player_entered(body: Node2D) -> void:
	if get_parent() is Level:
		get_parent().got_collectible = true
		get_tree().root.get_node("/root/GameMain/%FishBone").visible = true
		$SFX.play()
	
	animation_player.play("spin")
	await animation_player.animation_finished
	queue_free()
