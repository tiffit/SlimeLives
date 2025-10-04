class_name Projectile extends Entity

@onready var timer: Timer = $Timer
@onready var hitbox: CollisionShape2D = $DeathPlane/Area2D/CollisionShape2D
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var particle_spawn: Node2D = $ParticleSpawn

@export var particles: PackedScene

var lifetime: float = 1.0
var speed: float = 500.0
var direction: Vector2 = Vector2(0, 0)
var dead: bool = false
var level: Level

func _ready() -> void:
	timer.wait_time = lifetime
	timer.start()
	

func _physics_process(delta: float) -> void:
	if dead != true:
		position -= direction * speed * delta

func _on_timer_timeout() -> void:
	dead = true
	hitbox.disabled = true
	animation_player.play("dead")
	var particle = particles.instantiate()
	particle.position = position + direction * -50
	level.call_deferred("add_child", particle)
	await animation_player.animation_finished
	queue_free()
