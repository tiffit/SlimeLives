class_name Character extends CharacterBody2D

@export var speed: float = 400.0
@export var jump_speed: float = 600.0
@export var platform_scene: PackedScene
@export var item_entity_scene: PackedScene
@export var total_explode_time: float = 5
@export var death_menu_scene: PackedScene = preload("res://ui/death/death_screen.tscn")

@onready var slime_trail: GPUParticles2D = $SlimeTrail
@onready var slime_idle: GPUParticles2D = $SlimeIdle

const DEATH_PARTICLES = preload("uid://57xvg0lh3one")
const EXPLOSION_PARTICLES = preload("uid://bcpu36wcg5mid")

var gravity: float = ProjectSettings.get_setting("physics/2d/default_gravity")
var level: Level
var dead: bool = false
var item: Item = null
var external_velocity: Vector2 = Vector2()
var rng: RandomNumberGenerator = RandomNumberGenerator.new()

enum KillReason { ENTITY, TILE, BOUNDS }

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("spit"):
		if item:
			var item_entity: ItemEntity = item_entity_scene.instantiate()
			item_entity.item = item
			item_entity.position = position
			item_entity.total_explode_time = total_explode_time
			add_sibling(item_entity)
			var explode_time: float = 0
			if !$BombTimer.is_stopped():
				explode_time = $BombTimer.time_left
				$BombTimer.stop()
			item_entity.spit(self, explode_time)
			pickup_item(null)
			%SpitSound.pitch_scale = rng.randf_range(0.8, 1.2)
			%SpitSound.play()
		
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
	if horizontal != 0:
		$Body.flip_h = horizontal < 0
	
	# Jump
	var jumped: bool = false
	if is_on_floor() and Input.is_action_just_pressed("move_jump"):
		%JumpSound.pitch_scale = rng.randf_range(0.8, 1.2)
		%JumpSound.play()
		$Body.play("jump")
		jumped = true
		velocity.y = -jump_speed
	
	if %WindSound.playing:
		if external_velocity.is_zero_approx():
			%WindSound.stop()
	else:
		if !external_velocity.is_zero_approx():
			%WindSound.play()
		
	velocity += external_velocity
	external_velocity = Vector2()
	
	if is_on_floor():
		if velocity.x != 0:
			if !%WalkSound.playing:
				%WalkSound.play()
			if !jumped:
				$Body.play("walk")
		else:
			%WalkSound.stop()
			if !jumped:
				$Body.play("static")
	else:
		%WalkSound.stop()
		if $Body.animation != "jump":
			$Body.play("static")
	
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
		else:
			get_node("/root/GameMain/GameUI").add_child(death_menu_scene.instantiate())

func kill(reason: KillReason) -> void:
	if dead:
		return
	dead = true
	if level:
		%DeathSound.play()
		level.vignette.flash_vignette()
		SaveHelper.data.death_count += 1
		SaveHelper.save_data()
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
		platform.position += Vector2(0, -40)
		level.call_deferred("add_child", platform)

func pickup_item(item: Item):
	self.item = item
	if item:
		$ItemSprite.texture = item.texture
		if item.explode:
			$BombTimer.start(total_explode_time)
			%BombTickSound.pitch_scale = 1
			%BombTickSound.play()
		%PickUpItemSound.play()
	else:
		$ItemSprite.texture = null

func _on_bomb_timer_timeout() -> void:
	Item.create_explosion(self)
	var particles = EXPLOSION_PARTICLES.instantiate()
	particles.position = position
	level.call_deferred("add_child", particles)
	kill_and_respawn(Character.KillReason.ENTITY)

func _on_bomb_tick_sound_finished() -> void:
	if item and item.explode and !dead:
		var time_left_percent = $BombTimer.time_left / total_explode_time
		%BombTickSoundTimer.start(max(time_left_percent/2, 0.05))

func _on_bomb_tick_sound_timer_timeout() -> void:
	if item and item.explode and !dead:
		var timer_progress = 1 - $BombTimer.time_left / total_explode_time
		%BombTickSound.pitch_scale = 1 + timer_progress
		%BombTickSound.play()
