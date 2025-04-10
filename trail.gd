extends Sprite2D

func _ready() -> void:
	var tween = create_tween()
	tween.tween_property(self, "modulate:a", 0, 0.25).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_QUAD)
	tween.finished.connect(queue_free)
