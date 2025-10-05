@tool class_name Wind extends Area2D

@export var size: Vector2 = Vector2(20, 20):
	get:
		return size
	set(value):
		size = value
		if Engine.is_editor_hint():
			on_prop_changed()

@export var strength: float = 100:
	get:
		return strength
	set(value):
		strength = value
		if Engine.is_editor_hint():
			on_prop_changed()

func _ready() -> void:
	if !Engine.is_editor_hint():
		on_prop_changed()
		$Background.material = $Background.material.duplicate()
		$Background.material.set_shader_parameter("size", size)
	
func _physics_process(delta: float) -> void:
	if !Engine.is_editor_hint():
		var push_vec: Vector2 = Vector2(strength, 0)
		push_vec = push_vec.rotated(rotation)
		for body in get_overlapping_bodies():
			if body is Character:
				#push_vec /= Vector2(1, 5)
				body.external_velocity = push_vec
			elif body is Platform:
				if body.affected_by_wind:
					body.wind_velocity += push_vec
			elif body is TaoAnchor:
				body.wind_velocity += push_vec / 10

func on_prop_changed():
	if has_node("Shape") and has_node("Background"):
		$Shape.shape = RectangleShape2D.new()
		($Shape.shape as RectangleShape2D).size = size
		$Background.scale = size
