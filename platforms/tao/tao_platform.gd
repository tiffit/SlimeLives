class_name TaoPlatform extends Platform

var anchor: TaoAnchor
var angle: float # In degrees
var distance_from_anchor: float

func _ready() -> void:
	affected_by_wind = false
	if anchor:
		update_position()

func _process(delta: float) -> void:
	if !anchor:
		queue_free()
		return
		
	angle += 30.0*delta
	
	update_position()
	
func update_position():
	var rad: float = deg_to_rad(angle)
	var anchor_offset = Vector2(distance_from_anchor, 0).rotated(rad)
	position = anchor_offset + anchor.position
