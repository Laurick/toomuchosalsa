class_name PanelToast extends PanelContainer

@onready var texture_rect: TextureRect = $TextureRect

func show_text(item:GameItem) -> void:
	texture_rect.texture = load(item.item_image_path)
	var t = create_tween()
	t.tween_property(self, "scale", Vector2(1.1, 1.1), 0.4).set_trans(Tween.TRANS_BOUNCE).set_ease(Tween.EaseType.EASE_OUT)
	t.tween_property(self, "scale", Vector2(0, 0), 0.2).set_delay(2).set_ease(Tween.EaseType.EASE_OUT)
	await t.finished
