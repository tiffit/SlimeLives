class_name PressurePlate extends Area2D

@export var activation_id: int = 0
var activated: bool = false

func _on_body_entered(body: Node2D) -> void:
	if body is Character or body is ItemEntity:
		activate()

func _on_body_exited(body: Node2D) -> void:
	if body is Character or body is ItemEntity:
		call_deferred("try_deactivate")
	
func activate():
	if !activated:
		activated = true
		$ClickSound.pitch_scale = 1.2
		$ClickSound.play()
		for activatable in get_tree().get_nodes_in_group("activatable"):
			if activatable.has_method("activate"):
				activatable.activate(activation_id)

func try_deactivate():
	if get_overlapping_bodies().size() == 0:
		deactivate()

func deactivate():
	if activated:
		activated = false
		$ClickSound.pitch_scale = 0.6
		$ClickSound.play()
		for activatable in get_tree().get_nodes_in_group("activatable"):
			if activatable.has_method("activate"):
				activatable.deactivate(activation_id)
