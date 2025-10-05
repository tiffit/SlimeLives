class_name LevelInfo extends Resource

@export var levels: Array[PackedScene] = [] 

@export var region_names: Dictionary[Level.LevelRegion, String] = {
	Level.LevelRegion.TWISTED_FOREST: "Twisted Forest",
	Level.LevelRegion.POISON_SWAMP: "Poison Swamp",
	Level.LevelRegion.WITCH_TOWER: "Witch's Tower",
}

@export var region_bgs: Dictionary[Level.LevelRegion, Texture2D] = {
	Level.LevelRegion.TWISTED_FOREST: null,
	Level.LevelRegion.POISON_SWAMP: null,
	Level.LevelRegion.WITCH_TOWER: null,
}
