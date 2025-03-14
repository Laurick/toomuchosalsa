extends PanelContainer

@onready var master_container: HBoxContainer = $MarginContainer/VBoxContainer/MasterContainer
@onready var music_container: HBoxContainer = $MarginContainer/VBoxContainer/MusicContainer
@onready var sound_container: HBoxContainer = $MarginContainer/VBoxContainer/SoundContainer

func _ready() -> void:
	master_container.setup(AudioManager.volume_master)
	music_container.setup(AudioManager.volume_music)
	sound_container.setup(AudioManager.volume_sound)
	
func _on_master_container_value_changed(new_volume: float) -> void:
	AudioManager.change_volume_master(new_volume)


func _on_music_container_value_changed(new_volume: float) -> void:
	AudioManager.change_volume_music(new_volume)


func _on_sound_container_value_changed(new_volume: float) -> void:
	AudioManager.change_volume_sound(new_volume)
