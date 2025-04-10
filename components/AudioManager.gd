extends Node

@onready var sounds_audio_stream_player: AudioStreamPlayer = $SoundsAudioStreamPlayer
@onready var music_audio_stream_player: AudioStreamPlayer = $MusicAudioStreamPlayer
@onready var music_audio_stream_player_2: AudioStreamPlayer = $MusicAudioStreamPlayer2

var volume_master:float = 0.5
var volume_sound:float = 0.5
var volume_music:float = 0.5
var master_index:int
var music_index:int
var sound_index:int

var interjections_good = [
"res://audio/interjections/success_exclamation_2.wav",
"res://audio/interjections/success_exclamation_3.wav",
"res://audio/interjections/success_exclamation_4.wav",
"res://audio/interjections/success_exclamation_5.wav"]

var interjections_bad = ["res://audio/interjections/failure_exclamation_1.wav", 
"res://audio/interjections/failure_exclamation_2.wav", 
"res://audio/interjections/failure_exclamation_3.wav", 
"res://audio/interjections/failure_exclamation_4.wav"]

func _ready() -> void:
	master_index = AudioServer.get_bus_index("Master")
	music_index = AudioServer.get_bus_index("Music")
	sound_index = AudioServer.get_bus_index("SFX")
	change_volume_master(volume_master)
	change_volume_music(volume_music)
	change_volume_sound(volume_sound)

func change_volume_master(value:float) -> void:
	AudioServer.set_bus_volume_db(master_index, linear_to_db(value))
	volume_master = value


func change_volume_music(value:float) -> void:
	AudioServer.set_bus_volume_db(music_index, linear_to_db(value))
	volume_music = value


func change_volume_sound(value:float) -> void:
	AudioServer.set_bus_volume_db(sound_index, linear_to_db(value))
	volume_sound = value

func play_ambient_sound():
	var path = "res://components/AudioManager.tscn"
	music_audio_stream_player_2.stream = load("res://audio/song/ambient.wav")
	music_audio_stream_player_2.play()

func stop_ambient_sound():
	await create_tween().tween_property(music_audio_stream_player_2, "volume_db", -80, 4).finished
	music_audio_stream_player_2.stop()
	music_audio_stream_player_2.volume_db = 0
	
func play_sound(song_name:String):
	var path = "res://audio/%s" % song_name
	sounds_audio_stream_player.stream = load(path)
	sounds_audio_stream_player.pitch_scale = 1
	sounds_audio_stream_player.play()

func play_sound_random_pitch(song_name:String):
	var path = "res://audio/%s" % song_name
	sounds_audio_stream_player.stream = load(path)
	sounds_audio_stream_player.pitch_scale = randf_range(0.97, 1.03)
	sounds_audio_stream_player.play()
	
func play_music(song_name:String):
	if song_name == "":
		music_audio_stream_player.stop()
	else:
		var path = "res://audio/song/%s" % song_name
		music_audio_stream_player.stream = load(path)
		music_audio_stream_player.play()
		
	
func get_track_position()-> float:
	return music_audio_stream_player.get_playback_position()

func connect_finished(callable:Callable):
	music_audio_stream_player.finished.connect(callable)
	
func disconnect_finished(callable:Callable):
	music_audio_stream_player.finished.disconnect(callable)

func play_interjection_good():
	var picked = interjections_good.pick_random()
	music_audio_stream_player_2.stream = load(picked)
	music_audio_stream_player_2.seek(0)
	music_audio_stream_player_2.play()

func play_interjection_bad():
	var picked = interjections_bad.pick_random()
	music_audio_stream_player_2.stream = load(picked)
	music_audio_stream_player_2.seek(0)
	music_audio_stream_player_2.play()


func get_delay() -> float:
	var time = music_audio_stream_player.get_playback_position() + AudioServer.get_time_since_last_mix()
	time -= AudioServer.get_output_latency()
	#print("tiempo de delay: %d" % time)
	return time / 1000 # time was in seconds
