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
		
func spit():
	pickup_cooldown = 0.2
	var mouse_pos: Vector2 = get_viewport().get_mouse_position() / get_viewport_rect().size
	var angle: float = Vector2(.5, .5).angle_to_point(mouse_pos)
	var launch_vector: Vector2 = Vector2(1.0, 0).rotated(angle)
	call_deferred("apply_central_impulse", launch_vector * 1000)
		
func _process(delta: float) -> void:
	pickup_cooldown = max(0, pickup_cooldown - delta)

func _on_player_entered(body: Node2D) -> void:
	if pickup_cooldown == 0:
		if body is Character and not is_queued_for_deletion():
			if body.item == null:
				if item:
					body.pickup_item(item)
				queue_free()
