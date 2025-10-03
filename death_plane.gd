class_name Projectile extends DeathPlane

var speed: float = 100.0
var direction: float = 0

func _process(delta: float) -> void:
	pass


func _on_timer_timeout() -> void:
	queue_free()
