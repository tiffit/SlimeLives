@tool class_name Level extends Node2D

@export var level_width: int = 72
@export var level_height: int = 40
const tile_size: int = 16

var character: Character = null
var level_bounds: Rect2 = Rect2()

func _ready() -> void:
	level_bounds = Rect2(0, 0, level_width*tile_size, level_height*tile_size)
	respawn_character()

func _process(delta: float) -> void:
	if character != null:
		if character.position.y > level_bounds.end.y + tile_size*2:
			character.kill(Character.KillReason.BOUNDS)
			respawn_character()
	
	if Engine.is_editor_hint():
		queue_redraw()

func respawn_character():
	for child in get_children():
		if child is SpawnPoint:
			character = child.spawn_character()
			break
	
func _draw() -> void:
	if Engine.is_editor_hint():
		var debug_color: Color = Color8(255, 255, 255, 255)
		var debug_width: int = 3
		draw_line(Vector2(0, 0), Vector2(0, level_height)*tile_size, debug_color, debug_width, true)
		draw_line(Vector2(0, 0), Vector2(level_width, 0)*tile_size, debug_color, debug_width, true)
		draw_line(Vector2(level_width, 0)*tile_size, Vector2(level_width, level_height)*tile_size, debug_color, debug_width, true)
		draw_line(Vector2(0, level_height)*tile_size, Vector2(level_width, level_height)*tile_size, debug_color, debug_width, true)
	pass
