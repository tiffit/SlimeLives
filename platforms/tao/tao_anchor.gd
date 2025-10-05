class_name TaoAnchor extends RigidBody2D

@export var platform_scene: PackedScene
@export var platform_scene2: PackedScene
@export var platform_distance: float = 250.0

var platform1: TaoPlatform #left
var platform2: TaoPlatform #right

var wind_velocity: Vector2 = Vector2()

func _ready() -> void:
	platform1 = platform_scene.instantiate()
	platform1.distance_from_anchor = platform_distance
	platform1.angle = 180
	platform1.anchor = self
	add_sibling(platform1)

	platform2 = platform_scene2.instantiate()
	platform2.distance_from_anchor = platform_distance
	platform2.angle = 0
	platform2.anchor = self
	add_sibling(platform2)

func _integrate_forces(state: PhysicsDirectBodyState2D) -> void:
	linear_velocity = wind_velocity
	wind_velocity = Vector2()
