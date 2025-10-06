class_name WinScreen extends Control

@export var level_info: LevelInfo
var click_sound: AudioStream = preload("res://audio/sfx/click.wav")

func _ready() -> void:
	%FadeInPlayer.play("fade_in")
	%DeathsLabel.visible = false
	%DeathsText.visible = false
	%FishBonesLabel.visible = false
	%FishBonesText.visible = false
	%MainMenuButton.visible = false
	
	%DeathsText.text = "%d" % SaveHelper.data.death_count
	%FishBonesText.text = "%d/%d" % [SaveHelper.data.collected.size(), level_info.levels.size()]

func _on_deaths_timer_timeout() -> void:
	%DeathsLabel.visible = true
	%DeathsText.visible = true
	$DeathSound.play()
	
func _on_fish_bones_timer_timeout() -> void:
	%FishBonesLabel.visible = true
	%FishBonesText.visible = true
	$FishBoneSound.play()

func _on_main_menu_button_pressed() -> void:
	MusicController.play_one_shot(click_sound)
	get_tree().change_scene_to_file("res://ui/main_menu/main_menu.tscn")

func _on_main_menu_timer_timeout() -> void:
	%MainMenuButton.visible = true
	$MainMenuSound.play()
