class_name Character extends CharacterBody2D

@export var speed: float = 400.0
@export var jump_speed: float = 400.0
var gravity: float = ProjectSettings.get_setting("physics/2d/default_gravity")
var level: Level
var dead: bool = false

enum KillReason { ENTITY, TILE, BOUNDS }

func _physics_process(delta: float) -> void:
	# Gravity
	velocity.y += gravity * delta
	
	# Horizontal movement
	var horizontal: float = Input.get_axis("move_left", "move_right")
	velocity.x = horizontal * speed
	
	# Jump
	if is_on_floor() and Input.is_action_just_pressed("move_jump"):
		velocity.y = -jump_speed
	
	# Do movement physics
	move_and_slide()
	
func kill(reason: KillReason):
	dead = true
	if level:
		await level.play_circle(true).finished
	queue_free()
