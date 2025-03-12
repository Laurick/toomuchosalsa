extends HBoxContainer

signal value_changed(new_volume)

@onready var music_slider: HSlider = $VBoxContainer/MusicSlider
@onready var label: Label = $Label


func setup(volume):
	label.text = str(volume*100)
	music_slider.value = volume

func _on_music_slider_value_changed(value: float) -> void:
	label.text = str(value*100)


func _on_music_slider_drag_ended(is_value_changed: bool) -> void:
	if is_value_changed:
		AudioManager.play_one_shot("")
		value_changed.emit(music_slider.value)


func _on_music_slider_drag_started() -> void:
	AudioManager.play_one_shot("")
