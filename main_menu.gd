extends Control

@onready var config_container: PanelContainer = $ConfigContainer
@onready var controls_container: PanelContainer = $ControlsContainer
@onready var creditrs_container: PanelContainer = $CreditrsContainer

func _ready() -> void:
	AudioManager.play_ambient_sound()
	Tween
	
func _on_play_button_pressed() -> void:
	Constants.spectator_mode = false
	get_tree().change_scene_to_file("res://main.tscn")


func _on_config_button_pressed() -> void:
	config_container.show()


func _on_controls_button_pressed() -> void:
	controls_container.show()


func _on_spectator_button_pressed() -> void:
	Constants.spectator_mode = true
	get_tree().change_scene_to_file("res://main.tscn")


func _on_credits_button_pressed() -> void:
	creditrs_container.show()
