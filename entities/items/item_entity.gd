@tool class_name ItemEntity extends RigidBody2D

@export var item: Item:
	get:
		return item
	set(value):
		item = value
		update_render()

var pickup_cooldown: float = 0
var was_spit: bool = false
const explosion_radius = 4

func _ready() -> void:
	update_render()
	if item.animation:
		var anim = item.animation.instantiate()
		add_child(anim)
		anim.play("idle")

func update_render():
	if item:
		$ItemSprite.texture = item.texture
	else:
		$ItemSprite.texture = null
		
func spit(character: Character):
	was_spit = true
	if item.explode:
		$Timer.start()
	pickup_cooldown = 0.2
	$PickupArea.monitoring = false
	var mouse_pos: Vector2 = get_viewport().get_mouse_position() / get_viewport_rect().size
	var player_pos: Vector2 = character.get_global_transform_with_canvas().get_origin() / get_viewport_rect().size
	var angle: float = player_pos.angle_to_point(mouse_pos)
	var launch_vector: Vector2 = Vector2(1.0, 0).rotated(angle)
	call_deferred("apply_central_impulse", launch_vector * 1000)
	
		
func _process(delta: float) -> void:
	if !Engine.is_editor_hint():
		pickup_cooldown = max(0, pickup_cooldown - delta)
		if pickup_cooldown == 0:
			$PickupArea.monitoring = true

func _on_player_entered(body: Node2D) -> void:
	if item and item.explode and was_spit:
		return
	if body is Character and not is_queued_for_deletion():
		if body.item == null:
			if item:
				body.pickup_item(item)
			queue_free()

func _on_timer_timeout() -> void:
	if item.explode:
		var item_tile_pos: Vector2 = position / 5 / 16
		for child in get_parent().get_children():
			if child is TileMapLayer:
				for x in range(-explosion_radius, explosion_radius):
					for y in range(-explosion_radius, explosion_radius):
						var tile_pos: Vector2 = item_tile_pos + Vector2(x, y)
						var int_tile_pos: Vector2i = Vector2i(tile_pos)
						var tile_data: TileData = child.get_cell_tile_data(int_tile_pos)
						if tile_data:
							if tile_data.has_custom_data("fragile") and tile_data.get_custom_data("fragile"):
								child.erase_cell(int_tile_pos)
		queue_free()
