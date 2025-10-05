@tool class_name ItemEntity extends RigidBody2D
@onready var item_sprite: Sprite2D = $ItemSprite

@export var item: Item:
	get:
		return item
	set(value):
		item = value
		update_render()

var pickup_cooldown: float = 0
var was_spit: bool = false

func _ready() -> void:
	update_render()
	if item.animation:
		var anim = item.animation.instantiate()
		add_child(anim)
		anim.name = "ItemAnimation"
		anim.play("idle")

func update_render():
	if item:
		$ItemSprite.texture = item.texture
	else:
		$ItemSprite.texture = null
		
func spit(character: Character, explode_time: float = 0):
	was_spit = true
	if item.explode:
		$Timer.start(explode_time)
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
	if item and item.explode and has_node("ItemAnimation"):
		if was_spit and !$Timer.is_stopped():
			get_node("ItemAnimation").speed_scale = 2

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
		Item.create_explosion(self)
		if item.explosion:
			var explode = item.explosion.instantiate()
			add_child(explode)
			item_sprite.modulate = Color(1, 1, 1, 0)
			await get_tree().create_timer(1).timeout
			queue_free()
