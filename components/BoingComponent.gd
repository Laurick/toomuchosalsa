class_name BoingComponent extends Node

var target:Control 

func _ready() -> void:
	target = get_parent()
	target.visibility_changed.connect(_on_visibility_changed)

func _on_visibility_changed() -> void:
	if target.visible:
		create_tween().tween_property(target, "scale", Vector2.ONE, 0.1)
	else:
		create_tween().tween_property(target, "scale", Vector2.ZERO, 0.1)
