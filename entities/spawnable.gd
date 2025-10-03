class_name Spawnable extends Entity

@export var characterScene: PackedScene

func spawn_character(level: Level) -> Character:
	var character: Character = characterScene.instantiate()
	character.level = level
	character.position = position
	add_sibling(character)
	return character
