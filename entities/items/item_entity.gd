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
	call_deferred("apply_central_impulse", Vector2(0, -1000))
		
func _process(delta: float) -> void:
	pickup_cooldown = max(0, pickup_cooldown - delta)

func _on_player_entered(body: Node2D) -> void:
	if pickup_cooldown == 0:
		if body is Character and not is_queued_for_deletion():
			if body.item == null:
				if item:
					body.pickup_item(item)
				queue_free()
