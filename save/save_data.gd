class_name SaveData extends Resource

@export var collected: Array[String] = []
@export var completed: Array[String] = []
@export var volume: Dictionary[String, float] = {
"Master": 0.4,
"music": 1,
"sfx": 1
}
@export var comic_seen: bool = false
@export var death_count: int = 0
