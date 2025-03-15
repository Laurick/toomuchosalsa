extends Sprite2D


func _ready() -> void:
	var tween = get_tree().create_tween()
	tween.tween_property(self, "position:x", randf_range(-30,30), 0.5)
	tween.parallel().tween_property(self, "position:y", 50, 0.5)
	await tween.finished
	queue_free()

func set_perfect():
	texture = preload("res://images/perfecto.png")

func set_good():
	texture = preload("res://images/rico.png")

func set_bad():
	texture = preload("res://images/ay_mamita.png")
