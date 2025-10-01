class_name SpawnPoint extends Entity

@export var characterScene: PackedScene


func spawn_character() -> Character:
	var character: Character = characterScene.instantiate()
	character.position = position
	add_sibling(character)
	return character
