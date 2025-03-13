class_name GameManager extends Node

var score = 0
var balance_score = 0

@onready var spawn_manager: SpawnManager = %SpawnManager
@onready var canvas_layer: UI = $CanvasLayer
var song_idx = 0
var song_list = [
	"salsa.mp3","salsa2.wav"
]

func _ready() -> void:
	init_song()
	spawn_manager.note_failed.connect(fail)
	spawn_manager.note_success.connect(success)
	AudioManager.connect_finished(_on_song_finished)

func init_song():	
	
	if song_idx > song_list.size()-1:
		song_idx = 0
	AudioManager.play_music(song_list[song_idx])
	song_idx +=1
	spawn_manager.play_song("salsa")


#TODO ver tema puntuaciones

func fail():
	balance_score -= 1
	canvas_layer.update_score_label(balance_score)

func success(perfect:bool):
	balance_score += 1
	score = score + (balance_score)
	canvas_layer.update_score_label(balance_score)


func _on_song_finished():
	init_song()


func _on_tree_exited() -> void:
	AudioManager.disconnect_finished(_on_song_finished)
