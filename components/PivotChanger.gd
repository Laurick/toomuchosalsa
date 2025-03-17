class_name PivotChanger extends Control

var target

func _ready() -> void:
	target = get_parent()
	call_deferred("change_pivot")

func change_pivot():
	target.pivot_offset = position
