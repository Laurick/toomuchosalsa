extends Node2D
@export var center:Marker2D
@export var main:Node2D
func _process(delta: float) -> void:
	global_position = global_position + (global_position.direction_to(center.global_position)*2)
	if global_position.distance_to(center.global_position) == 0:
		main.fail()
		queue_free()
