class_name GameManager extends Node

var delay = 1.2
var score = 0
var balance_score = 0
var loop_dance_score = 0
var song_playing = false

@onready var spawn_manager: SpawnManager = %SpawnManager
@onready var canvas_layer: UI = $CanvasLayer
@onready var dancers: AnimatedSprite2D = $Game/Dancers


var song_idx = 0
var song_list = [
	{"song": "music_loop_1.wav", "inputs": "res://audio/song/music_loop_1.tres", "text":"res://audio/song/music_loop_1_sub.tres"},
	{"song": "music_loop_2.wav", "inputs": "res://audio/song/music_loop_2.tres", "text":"res://audio/song/music_loop_2_sub.tres"},
	{"song": "music_loop_3.wav", "inputs": "res://audio/song/music_loop_3.tres", "text":"res://audio/song/music_loop_3_sub.tres"},
	{"song": "music_loop_4.wav", "inputs": "res://audio/song/music_loop_4.tres", "text":"res://audio/song/music_loop_4_sub.tres"},
	{"song": "music_loop_5.wav", "inputs": "res://audio/song/music_loop_5.tres", "text":"res://audio/song/music_loop_5_sub.tres"},
	{"song": "music_loop_6.wav", "inputs": "res://audio/song/music_loop_6.tres", "text":"res://audio/song/music_loop_6_sub.tres"},
	{"song": "music_loop_7.wav", "inputs": "res://audio/song/music_loop_7.tres", "text":"res://audio/song/music_loop_7_sub.tres"},
	{"song": "music_loop_8.wav", "inputs": "res://audio/song/music_loop_8.tres", "text":"res://audio/song/music_loop_8_sub.tres"},
	{"song": "music_loop_9.wav", "inputs": "res://audio/song/music_loop_9.tres", "text":"res://audio/song/music_loop_9_sub.tres"},
	{"song": "music_loop_10.wav", "inputs": "res://audio/song/music_loop_10.tres", "text":"res://audio/song/music_loop_10_sub.tres"},
]
var srt_parser:SRTParser = SRTParser.new()
var subtitles:Array[SubtitleEntry] = []
var srt_time:float = 0

func _ready() -> void:

	var tween = get_tree().create_tween()
	var down_time = 0.4
	tween.tween_property($Game/Curtain, "position:y", 50, down_time)
	tween.tween_property($Game/Curtain, "position:y", -750, delay-down_time)
	await tween.finished
	init_song(false)
	spawn_manager.note_failed.connect(fail)
	spawn_manager.note_success.connect(success)
	AudioManager.connect_finished(_on_song_finished)
	await get_tree().create_timer(delay).timeout
	init_music_track(false)


func init_song(looped:bool = true):
	if looped && loop_dance_score == 0 :
		song_idx +=1
		AudioManager.play_interjection_good()
	else:
		if looped:
			AudioManager.play_interjection_bad()
	if song_idx > song_list.size()-1:
		win_game()
		return
	loop_dance_score = 0
	var song = song_list[song_idx]
	
	spawn_manager.play_song(song["inputs"])
	subtitles = srt_parser.parse_srt_file(song["text"])
	srt_time = 0

#TODO ver tema puntuaciones
func init_music_track(looped:bool = true):
	dancers.play("default")
	$Game/AnimatedSprite2D2.play("default")
	$Game/AnimatedSprite2D3.play("default")
	var song = song_list[song_idx]
	AudioManager.play_music(song["song"])
	song_playing = true


func fail():
	if dancers.animation != &"error":
		dancers.play(&"error")
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
		if int(AudioManager.get_track_position()) > 19.2-delay:
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


func _on_tick_ticked(tick_number: Variant) -> void:
	pass # use to change animations?
