class_name Platform extends AnimatableBody2D

var affected_by_wind: bool = true
var wind_velocity: Vector2 = Vector2()

func _physics_process(delta: float) -> void:
	if !wind_velocity.is_zero_approx():
		constant_linear_velocity = -wind_velocity
		move_and_collide(wind_velocity*delta)
		wind_velocity = Vector2()
	else:
		constant_linear_velocity = Vector2()
