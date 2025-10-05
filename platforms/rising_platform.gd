class_name RisingPlatform extends Platform

var is_rising: bool = false
var initial_y: float = 0
var rise_speed: float = 250
var fall_speed: float = 150
var player: Character = null
var ceiling_padding: float
var old_wind_velocity = Vector2()

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
	var wind = old_wind_velocity*delta
	if is_rising and player.is_on_floor():
		var move_amount: float = -rise_speed*delta
		if position.y - ceiling_padding + move_amount < 0:
			move_amount = -(position.y - ceiling_padding)
		move_and_collide(Vector2(0, move_amount) + wind)
	else:
		var distance: float = initial_y - position.y
		var move_amount: float = fall_speed*delta
		if distance < move_amount:
			move_amount = distance
		move_and_collide(Vector2(0, move_amount) + wind)
	initial_y += wind.y
	
	
func _physics_process(delta: float) -> void:
	old_wind_velocity = wind_velocity
	wind_velocity = Vector2()
