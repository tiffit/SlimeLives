class_name Vignette extends ColorRect

var shader_material = material as ShaderMaterial

func _ready() -> void:
	change_progresss(0.0)

func flash_vignette():
	var tween = create_tween()
	tween.tween_method(change_progresss, 0.0, 1.0, 0.2).set_trans(Tween.TRANS_LINEAR)
	tween.tween_method(change_progresss, 1.0, 0.0, 0.5).set_trans(Tween.TRANS_LINEAR)
	tween.play()
		
func change_progresss(value: float):
	shader_material.set_shader_parameter("progress", value)
