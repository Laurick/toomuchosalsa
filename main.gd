class_name GameManager extends Node

var score = 0
var balance_score = 0
var loop_dance_score = 0
var song_playing = false

@onready var spawn_manager: SpawnManager = %SpawnManager
@onready var canvas_layer: UI = $CanvasLayer


var song_idx = 0
var song_list = [
	{"song": "clicktrack.mp3", "inputs": "res://audio/song/salsa.txt", "text":"res://audio/song/song.txt", "len":19.20},
	{"song": "salsa.mp3", "inputs": "res://audio/song/salsa.txt", "text":"res://audio/song/song.txt", "len":19.20},
	{"song": "salsa_old.mp3", "inputs": "res://audio/song/salsa.txt", "text":"res://audio/song/song.txt","len":19.20}
]
var delay = 1.15
var srt_parser:SRTParser = SRTParser.new()
var subtitles:Array[SubtitleEntry] = []
var srt_time:float = 0

func _ready() -> void:

	init_song(false)
	var tween = get_tree().create_tween()
	tween.tween_property($Game/Curtain, "position:y", -600, delay)
	await get_tree().create_timer(delay).timeout
	init_music_track(false)
	spawn_manager.note_failed.connect(fail)
	spawn_manager.note_success.connect(success)
	AudioManager.connect_finished(_on_song_finished)


func init_song(looped:bool = true):
	
	if looped && loop_dance_score == 0 :
		song_idx +=1
	if song_idx > song_list.size()-1:
		await get_tree().create_timer(delay).timeout
		win_game()
		return
	loop_dance_score = 0
	var song = song_list[song_idx]
	
	spawn_manager.play_song(song["inputs"])
	subtitles = srt_parser.parse_srt_file(song["text"])
	srt_time = 0

#TODO ver tema puntuaciones
func init_music_track(looped:bool = true):
	$Game/AnimatedSprite2D.play("default")
	var song = song_list[song_idx]
	AudioManager.play_music(song["song"])
	song_playing = true
	
func fail():
	balance_score -= 1
	loop_dance_score -= 1
	canvas_layer.update_score_label(balance_score)


func success(perfect:bool):
	balance_score += 1
	score = score + (balance_score)
	canvas_layer.update_score_label(balance_score)


func _process(delta: float) -> void:
	srt_time += delta
	
	if song_playing:
		if int(AudioManager.get_track_position()) > song_list[song_idx].len-delay:
			song_playing = false
			init_song()
	var subtitle:SubtitleEntry = srt_parser.get_subtitle_at_time(subtitles, srt_time)
	if subtitle:
		canvas_layer.add_subtitle(subtitle, srt_time)
	else:
		canvas_layer.add_subtitle()

func _on_song_finished():
	init_music_track()


func _on_tree_exited() -> void:
	AudioManager.disconnect_finished(_on_song_finished)


func _on_exit_button_pressed() -> void:
	AudioManager.play_music("")
	get_tree().paused = false
	get_tree().change_scene_to_file("res://main_menu.tscn")


func win_game():
	AudioManager.play_music("")
	get_tree().change_scene_to_file("res://win.tscn")
