extends Node2D
@export var center:Marker2D

func _process(delta: float) -> void:
	global_position = global_position + (global_position.direction_to(center.global_position)*2)
