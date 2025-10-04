class_name Character extends CharacterBody2D

@export var speed: float = 400.0
@export var jump_speed: float = 600.0
@export var platform_scene: PackedScene
@export var item_entity_scene: PackedScene

@onready var slime_trail: GPUParticles2D = $SlimeTrail
@onready var slime_idle: GPUParticles2D = $SlimeIdle

const DEATH_PARTICLES = preload("uid://57xvg0lh3one")

var gravity: float = ProjectSettings.get_setting("physics/2d/default_gravity")
var level: Level
var dead: bool = false
var item: Item = null

enum KillReason { ENTITY, TILE, BOUNDS }

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("spit"):
		if item:
			var item_entity: ItemEntity = item_entity_scene.instantiate()
			item_entity.item = item
			item_entity.position = position
			add_sibling(item_entity)
			item_entity.spit()
			pickup_item(null)
	
		
func _physics_process(delta: float) -> void:
	if velocity.x != 0:
		slime_idle.emitting = false
		slime_trail.emitting = true
	elif velocity.y != 0 and dead != true:
		slime_idle.emitting = false
		slime_trail.emitting = true
	elif dead != true:
		slime_idle.emitting = true
		slime_trail.emitting = false
	else:
		slime_idle.emitting = false
		slime_trail.emitting = false

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
		get_node("/root/GameMain/GameUI/UI").heart_icon.play_swing()
		if level.lives >= 0:
			level.respawn_character()

func kill(reason: KillReason) -> void:
	if dead:
		return
	dead = true
	if level:
		level.vignette.flash_vignette()
		if reason != KillReason.BOUNDS:
			get_node("/root/GameMain").i_died.emit()
			$AnimationPlayer.play("death")
			await $AnimationPlayer.animation_finished
			var particles = DEATH_PARTICLES.instantiate()
			particles.position = position + Vector2(0, -50)
			level.call_deferred("add_child", particles)
			spawn_platform()
		await level.play_circle(true).finished
		level.lives -= 1
	queue_free()

func spawn_platform():
	var scene: PackedScene = item.platform if item else platform_scene
	if scene:
		var platform: Node2D = scene.instantiate()
		platform.position = position
		platform.position += Vector2(0, -50)
		level.call_deferred("add_child", platform)

func pickup_item(item: Item):
	self.item = item
	if item:
		$ItemSprite.texture = item.texture
	else:
		$ItemSprite.texture = null
