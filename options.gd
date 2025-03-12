extends PanelContainer

@onready var master_container: HBoxContainer = $MarginContainer/VBoxContainer/MasterContainer
@onready var music_container: HBoxContainer = $MarginContainer/VBoxContainer/MusicContainer
@onready var sound_container: HBoxContainer = $MarginContainer/VBoxContainer/SoundContainer

func _on_master_container_value_changed(new_volume: float) -> void:
	AudioManager.set_volume_to_vca("Master", new_volume)


func _on_music_container_value_changed(new_volume: float) -> void:
	AudioManager.set_volume_to_vca("Music", new_volume)


func _on_sound_container_value_changed(new_volume: float) -> void:
	AudioManager.set_volume_to_vca("SFX", new_volume)


func _on_visibility_changed() -> void:
	if visible:
		create_tween().tween_property(self, "scale", Vector2.ONE, 0.3).set_trans(Tween.TRANS_BOUNCE).set_ease(Tween.EaseType.EASE_OUT)
	else:
		create_tween().tween_property(self, "scale", Vector2.ZERO, 0.3).set_trans(Tween.TRANS_BOUNCE).set_ease(Tween.EaseType.EASE_OUT)
