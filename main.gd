class_name GameManager extends Node

var time_delay = 0
const delay = 1.2
const time_loop = 19.2
const time_to_cheer = 18
var score = 0
var balance_score = 0
var loop_dance_score = 0
var song_playing = false
var interjection_played = true
var playing = false

@onready var color_rect: ColorRect = $CanvasLayer/ColorRect
@onready var spawn_manager: SpawnManager = %SpawnManager
@onready var canvas_layer: UI = $CanvasLayer
@onready var dancers: AnimatedSprite2D = $Game/Dancers


var song_idx = 0
var song_list = [
	{"song": "music_intro.wav", "inputs": "res://audio/song/music_intro.tres", "text":"res://audio/song/music_intro_sub.tres", "len":30.3},
	{"song": "music_loop_1.wav", "inputs": "res://audio/song/music_loop_1.tres", "text":"res://audio/song/music_loop_1_sub.tres", "len":19.2},
	{"song": "music_loop_2.wav", "inputs": "res://audio/song/music_loop_2.tres", "text":"res://audio/song/music_loop_2_sub.tres", "len":19.2},
	{"song": "music_loop_3.wav", "inputs": "res://audio/song/music_loop_3.tres", "text":"res://audio/song/music_loop_3_sub.tres", "len":19.2},
	{"song": "music_loop_4.wav", "inputs": "res://audio/song/music_loop_4.tres", "text":"res://audio/song/music_loop_4_sub.tres", "len":19.2},
	{"song": "music_loop_5.wav", "inputs": "res://audio/song/music_loop_5.tres", "text":"res://audio/song/music_loop_5_sub.tres", "len":19.2},
	{"song": "music_loop_6.wav", "inputs": "res://audio/song/music_loop_6.tres", "text":"res://audio/song/music_loop_6_sub.tres", "len":19.2},
	{"song": "music_loop_7.wav", "inputs": "res://audio/song/music_loop_7.tres", "text":"res://audio/song/music_loop_7_sub.tres", "len":19.2},
	{"song": "music_loop_8.wav", "inputs": "res://audio/song/music_loop_8.tres", "text":"res://audio/song/music_loop_8_sub.tres", "len":19.2},
	{"song": "music_loop_9.wav", "inputs": "res://audio/song/music_loop_9.tres", "text":"res://audio/song/music_loop_9_sub.tres", "len":19.2},
	{"song": "music_loop_10.wav", "inputs": "res://audio/song/music_loop_10.tres", "text":"res://audio/song/music_loop_10_sub.tres", "len":19.2},
]
var srt_parser:SRTParser = SRTParser.new()
var subtitles:Array[SubtitleEntry] = []
var srt_time:float = 0
var start = false

func _ready() -> void:
	var tween = get_tree().create_tween()
	var down_time = 0.4
	tween.tween_property($Game/Curtain, "position:y", 50, down_time).set_ease(Tween.EASE_OUT)
	tween.tween_property($Game/Curtain, "position:y", -750, delay-down_time).set_ease(Tween.EASE_IN)
	await tween.finished
	init_song(false)
	spawn_manager.note_failed.connect(fail)
	spawn_manager.note_success.connect(success)
	AudioManager.connect_finished(_on_song_finished)


func init_song(looped:bool = true):
	if looped and loop_dance_score == 0:
		song_idx +=1
	if looped:
		loop_dance_score = 0
		interjection_played = false
		playing = false
	if song_idx > song_list.size()-1:
		win_game()
		return

	var song = song_list[song_idx]
	
	if !Constants.spectator_mode:
		spawn_manager.play_song(song["inputs"])


#TODO ver tema puntuaciones
func init_music_track(_looped:bool = true):
	dancers.play("default")
	$Game/AnimatedSprite2D2.play("default")
	$Game/AnimatedSprite2D3.play("default")
	var song = song_list[song_idx]
	AudioManager.play_music(song["song"])
	song_playing = true
	subtitles = srt_parser.parse_srt_file(song["text"])
	srt_time = 0

func fail():
	if dancers.animation != &"error":
		dancers.play(&"error")
	balance_score -= 1
	loop_dance_score -= 1
	canvas_layer.update_score_label(balance_score)


func success(special:bool):
	if special && dancers.animation != &"error" && !dancers.animation.begins_with("special"):
		dancers.play(&"special_"+["a","b","c"].pick_random())
	balance_score += 1
	score = score + (balance_score)
	canvas_layer.update_score_label(balance_score)


func _process(delta: float) -> void:
	srt_time += delta
	
	if !start and srt_time >= delay:
		start = true
		canvas_layer.show_pause_button()
		init_music_track(false)

	if song_playing:
		if float(AudioManager.get_track_position()) > song_list[song_idx].len-delay:
			song_playing = false
			if !interjection_played:
				interjection_played = true
				if loop_dance_score == 0:
					AudioManager.play_interjection_good()
				else:
					AudioManager.play_interjection_bad()
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
	canvas_layer.hide_pause_button()
	playing = false
	AudioManager.play_music("music_outro.wav")
	# bye dancers
	dancers.play("walk")
	while dancers.position.x > -800:
		await get_tree().create_timer(1.2).timeout
		dancers.position = Vector2(dancers.position.x-220, dancers.position.y)

	#curtain
	var tween = get_tree().create_tween()
	tween.tween_property($Game/Curtain, "position:y", 50, 5).set_ease(Tween.EASE_OUT)
	tween.tween_property($Game/Curtain, "position:y", 0, 1).set_ease(Tween.EASE_IN)

	while dancers.position.x > -1200:
		await get_tree().create_timer(1.2).timeout
		dancers.position = Vector2(dancers.position.x-220, dancers.position.y)
	
	await create_tween().tween_property(color_rect, "modulate:a", 1, 12).finished
	get_tree().change_scene_to_file("res://win.tscn")

var play_default = false
func _on_dancers_animation_finished() -> void:
	if dancers.animation == &"error":
		play_default = true


func _on_ticker_on_tick_ticked(_tick_number: Variant) -> void:
	if play_default:
		dancers.play(&"default")
		play_default = false
