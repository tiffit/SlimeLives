extends ColorRect

var shader_material = material as ShaderMaterial

func _ready() -> void:
	shader_material.set_shader_parameter("screen_width", get_viewport_rect().size.x)
	shader_material.set_shader_parameter("screen_height", get_viewport_rect().size.y)
	play_circle(200, 200, false)

func _process(delta: float) -> void:
	shader_material.set_shader_parameter("screen_width", get_viewport_rect().size.x)
	shader_material.set_shader_parameter("screen_height", get_viewport_rect().size.y)
	
func play_circle(player_x, player_y, close: bool = true):
	shader_material.set_shader_parameter("player_x", player_x)
	shader_material.set_shader_parameter("player_y", player_y)
	
	
	var tween = create_tween()
	if close:
		tween.tween_method(change_circle_size, 2.0, 0.0, 0.5).set_trans(Tween.TRANS_LINEAR).set_delay(1)
	else:
		change_circle_size(0.0)
		tween.tween_method(change_circle_size, 0.0, 2.0, 0.5).set_trans(Tween.TRANS_LINEAR).set_delay(1)
	
func change_circle_size(circle_size: float):
	shader_material.set_shader_parameter("circle_size", circle_size)
