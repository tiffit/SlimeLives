class_name Item extends Resource

@export var item_name: String
@export var texture: Texture2D
@export var platform: PackedScene
@export var explode: bool = false
@export var animation: PackedScene
@export var explosion: PackedScene
const explosion_radius = 2

static func create_explosion(node: Node2D):
	var item_tile_pos: Vector2 = node.position / 5 / 16
	for child in node.get_parent().get_children():
		if child is TileMapLayer:
			for x in range(-explosion_radius, explosion_radius):
				for y in range(-explosion_radius, explosion_radius):
					var tile_pos: Vector2 = item_tile_pos + Vector2(x, y)
					var int_tile_pos: Vector2i = Vector2i(tile_pos)
					var tile_data: TileData = child.get_cell_tile_data(int_tile_pos)
					if tile_data:
						if tile_data.has_custom_data("fragile") and tile_data.get_custom_data("fragile"):
							child.erase_cell(int_tile_pos)
