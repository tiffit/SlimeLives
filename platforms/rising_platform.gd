class_name RisingPlatform extends AnimatableBody2D

var is_rising: bool = false
var initial_y: float = 0
var rise_speed: float = 100
var fall_speed: float = 300
var player: Character = null
var ceiling_padding: float

func _ready() -> void:
	initial_y = position.y
	ceiling_padding = $CollisionShape2D.shape.size.y/2

func _on_player_land(body: Node2D) -> void:
	if body is Character:
		is_rising = true
		player = body
			
func _on_player_leave(body: Node2D) -> void:
	if body is Character:
		is_rising = false
		player = null

func _process(delta: float) -> void:
	if is_rising and player.is_on_floor():
		var move_amount: float = -rise_speed*delta
		if position.y - ceiling_padding + move_amount < 0:
			move_amount = -(position.y - ceiling_padding)
		move_and_collide(Vector2(0, move_amount))
	else:
		var distance: float = initial_y - position.y
		var move_amount: float = fall_speed*delta
		if distance < move_amount:
			move_amount = distance
		
		move_and_collide(Vector2(0, move_amount))
	
