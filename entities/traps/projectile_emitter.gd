@tool
class_name ProjectileEmitter extends Node2D

@onready var offset: Timer = $Offset
@onready var timer: Timer = $Timer
@onready var trajectory: ColorRect = $ColorRect

@export var proj: PackedScene
@export_range(100.0, 5000.0, 10.0) var projSpeed: float = 500.0
@export_range(0.1, 10.0, 0.02) var projLifetime: float = 1.0
@export_range(0.1, 10.0, 0.1) var cooldown: float = 1.0
@export_range(0.0, 10.0, 0.1) var timer_offset: float = 0.0

var level: Level

func _ready() -> void:
	timer.wait_time = cooldown
	if timer_offset == 0.0:
		if proj and level:
			var projectile = proj.instantiate()
			projectile.position = position
			projectile.speed = projSpeed
			projectile.rotate(rotation)
			projectile.direction = Vector2(cos((rotation)), sin((rotation))).normalized()
			projectile.lifetime = projLifetime
			projectile.level = level
			level.call_deferred("add_child", projectile)
		timer.start()
	else:
		offset.wait_time = timer_offset
		offset.start()
	
	if not Engine.is_editor_hint():
		Globals.find_my_level.connect(on_level_find)
		level = get_node("/root/GameMain/Level")
		

func _process(delta: float) -> void:
	if Engine.is_editor_hint():
		trajectory.visible = true
		trajectory.size.x = projSpeed * projLifetime + 80.0
	else:
		trajectory.visible = false

func _on_timer_timeout() -> void:
	if proj and level:
		var projectile = proj.instantiate()
		projectile.position = position
		projectile.speed = projSpeed
		projectile.rotate(rotation)
		projectile.direction = Vector2(cos((rotation)), sin((rotation))).normalized()
		projectile.lifetime = projLifetime
		projectile.level = level
		level.call_deferred("add_child", projectile)
		$ShootSound.play()
		#add_child(projectile)

func on_level_find(piss: Level) -> void:
	level = piss


func _on_offset_timeout() -> void:
	if proj and level:
		var projectile = proj.instantiate()
		projectile.position = position
		projectile.speed = projSpeed
		projectile.rotate(rotation)
		projectile.direction = Vector2(cos((rotation)), sin((rotation))).normalized()
		projectile.lifetime = projLifetime
		projectile.level = level
		level.call_deferred("add_child", projectile)
	timer.start()
