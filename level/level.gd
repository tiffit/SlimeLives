@tool class_name Level extends Node2D

@export var level_name: String = "Unnamed"
@export var level_width: int = 72
@export var level_height: int = 40
const tile_size: int = 16

var camera: Camera2D
var character: Character = null
var level_bounds: Rect2 = Rect2()
var circle_transition: CircleTransition
var vignette: Vignette
var current_spawn: Spawnable = null
var lives = 9

func _ready() -> void:
	level_bounds = Rect2(0, 0, level_width*tile_size, level_height*tile_size)
	if not Engine.is_editor_hint():
		camera = get_node("Camera2D")
		circle_transition = get_node("../GameUI/SceneTransition")
		vignette = get_node("../GameUI/Vignette")
	
		# Find Spawnpoint
		for child in get_children():
			if child is SpawnPoint:
				current_spawn = child
				break
		
		respawn_character()

func _process(delta: float) -> void:
	if character != null and not character.dead:
		if character.position.y > level_bounds.end.y + tile_size*2:
			await character.kill_and_respawn(Character.KillReason.BOUNDS)
	
	# Camera movement
	move_camera()

	if Engine.is_editor_hint():
		queue_redraw()

func move_camera():
	if camera:
		var viewport: Rect2 = camera.get_viewport_rect()
		if character:
			if viewport.size.y >= level_bounds.size.y:
				camera.position.y = level_bounds.size.y / 2
			else:
				camera.position.y = character.position.y
				if (camera.position.y - viewport.size.y/2) < level_bounds.position.y:
					camera.position.y = level_bounds.position.y + viewport.size.y/2
				elif (camera.position.y + viewport.size.y/2) > level_bounds.end.y:
					camera.position.y = level_bounds.end.y - viewport.size.y/2
			
			if viewport.size.x >= level_bounds.size.x:
				camera.position.x = level_bounds.size.x / 2
			else:
				camera.position.x = character.position.x
				if (camera.position.x - viewport.size.x/2) < level_bounds.position.x:
					camera.position.x = level_bounds.position.x + viewport.size.x/2
				elif (camera.position.x + viewport.size.x/2) > level_bounds.end.x:
					camera.position.x = level_bounds.end.x - viewport.size.x/2

func respawn_character():
	if current_spawn:
		character = current_spawn.spawn_character(self)
		move_camera()
		play_circle(false)
	
func play_circle(close: bool) -> MethodTweener:
	if circle_transition:
		var pos_x: float = character.position.x if character else 0
		var pos_y: float = character.position.y if character else 0
		var camera_offset_x: float = camera.get_viewport_rect().size.x/2 - camera.position.x
		var camera_offset_y: float = camera.get_viewport_rect().size.y/2 - camera.position.y
		return circle_transition.play_circle(pos_x + camera_offset_x, pos_y + camera_offset_y, close)
	return null
		
func _draw() -> void:
	if Engine.is_editor_hint():
		var debug_color: Color = Color8(255, 255, 255, 255)
		var debug_width: int = 3
		draw_line(Vector2(0, 0), Vector2(0, level_height)*tile_size, debug_color, debug_width, true)
		draw_line(Vector2(0, 0), Vector2(level_width, 0)*tile_size, debug_color, debug_width, true)
		draw_line(Vector2(level_width, 0)*tile_size, Vector2(level_width, level_height)*tile_size, debug_color, debug_width, true)
		draw_line(Vector2(0, level_height)*tile_size, Vector2(level_width, level_height)*tile_size, debug_color, debug_width, true)
	pass
