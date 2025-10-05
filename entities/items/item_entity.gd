@tool class_name ItemEntity extends RigidBody2D

@export var item: Item:
	get:
		return item
	set(value):
		item = value
		update_render()

var pickup_cooldown: float = 0

func _ready() -> void:
	update_render()

func update_render():
	if item:
		$ItemSprite.texture = item.texture
	else:
		$ItemSprite.texture = null
		
func spit(character: Character):
	pickup_cooldown = 0.2
	$Area2D.monitoring = false
	var mouse_pos: Vector2 = get_viewport().get_mouse_position() / get_viewport_rect().size
	var player_pos: Vector2 = character.get_global_transform_with_canvas().get_origin() / get_viewport_rect().size
	var angle: float = player_pos.angle_to_point(mouse_pos)
	var launch_vector: Vector2 = Vector2(1.0, 0).rotated(angle)
	call_deferred("apply_central_impulse", launch_vector * 1000)
		
func _process(delta: float) -> void:
	pickup_cooldown = max(0, pickup_cooldown - delta)
	if pickup_cooldown == 0:
		$Area2D.monitoring = true

func _on_player_entered(body: Node2D) -> void:
	if body is Character and not is_queued_for_deletion():
		if body.item == null:
			if item:
				body.pickup_item(item)
			queue_free()
