@tool class_name ItemEntity extends RigidBody2D

@export var item: Item:
	get:
		return item
	set(value):
		item = value
		update_render()
		
func _ready() -> void:
	update_render()

func update_render():
	if item:
		$ItemSprite.texture = item.texture
	else:
		$ItemSprite.texture = null
		
func _on_player_entered(body: Node2D) -> void:
	if body is Character and not is_queued_for_deletion():
		if body.item == null:
			if item:
				body.pickup_item(item)
			queue_free()
