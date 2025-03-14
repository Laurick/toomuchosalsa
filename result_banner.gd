extends Node2D


func _ready() -> void:
	var tween = get_tree().create_tween()
	tween.tween_property(self, "position:x", randf_range(-30,30), 0.5)
	tween.parallel().tween_property(self, "position:y", 50, 0.5)
	await tween.finished
	queue_free()

func set_image(image:Texture):
	$Sprite2D.texture = image
