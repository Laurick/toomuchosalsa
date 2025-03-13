extends Control

@onready var config_container: PanelContainer = $ConfigContainer
@onready var controls_container: PanelContainer = $ControlsContainer

func _on_play_button_pressed() -> void:
	get_tree().change_scene_to_file("res://main.tscn")


func _on_config_button_pressed() -> void:
	config_container.show()


func _on_controls_button_pressed() -> void:
	controls_container.show()
