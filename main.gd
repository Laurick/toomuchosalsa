class_name GameManager extends Node

var score = 0
var balance_score = 0

@onready var spawn_manager: SpawnManager = %SpawnManager
@onready var canvas_layer: UI = $CanvasLayer

func _ready() -> void:
	AudioManager.play_music("salsa")
	spawn_manager.play_song("salsa")
	spawn_manager.note_failed.connect(fail)
	spawn_manager.note_success.connect(success)


#TODO ver tema puntuaciones

func fail():
	balance_score -= 1
	canvas_layer.update_score_label(balance_score)

func success():
	balance_score += 1
	score = score + (balance_score)
	canvas_layer.update_score_label(balance_score)
