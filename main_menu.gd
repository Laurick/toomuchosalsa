extends Control

func _ready() -> void:
	Constants.show_tutorial = true
	AudioFMod.reset_music()

func _on_button_pressed() -> void:
	FmodServer.play_one_shot("event:/FX/UI/Accpet")
	get_tree().change_scene_to_file("res://main.tscn")

func _on_ui_button_pressed() -> void:
	FmodServer.play_one_shot("event:/FX/UI/Cancel_Back")
