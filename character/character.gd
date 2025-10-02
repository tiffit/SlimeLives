class_name Character extends CharacterBody2D

@export var speed: float = 400.0
@export var jump_speed: float = 600.0
@export var platform_scene: PackedScene
const DEATH_PARTICLES = preload("uid://57xvg0lh3one")

var gravity: float = ProjectSettings.get_setting("physics/2d/default_gravity")
var level: Level
var dead: bool = false

enum KillReason { ENTITY, TILE, BOUNDS }

func _physics_process(delta: float) -> void:
	if dead:
		return
		
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

func kill_and_respawn(reason: KillReason) -> void:
	if dead:
		return
	await kill(reason)
	if level:
		level.respawn_character()

func kill(reason: KillReason):
	if dead:
		return
	dead = true
	if level:
		if reason != KillReason.BOUNDS:
			if platform_scene:
				$AnimationPlayer.play("death")
				await $AnimationPlayer.animation_finished
				var particles = DEATH_PARTICLES.instantiate()
				particles.position = position + Vector2(0, -50)
				level.call_deferred("add_child", particles)
				var platform: Node2D = platform_scene.instantiate()
				platform.position = position
				platform.position += Vector2(0, -50)
				level.call_deferred("add_child", platform)
				
		await level.play_circle(true).finished
	queue_free()
