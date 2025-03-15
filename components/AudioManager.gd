extends Node

@onready var sounds_audio_stream_player: AudioStreamPlayer = $SoundsAudioStreamPlayer
@onready var music_audio_stream_player: AudioStreamPlayer = $MusicAudioStreamPlayer

var volume_master:float = 0.5
var volume_sound:float = 0.5
var volume_music:float = 0.5
var master_index:int
var music_index:int
var sound_index:int

func _ready() -> void:
	change_volume_master(volume_master)
	change_volume_music(volume_music)
	change_volume_sound(volume_sound)
	master_index = AudioServer.get_bus_index("Master")
	music_index = AudioServer.get_bus_index("Music")
	sound_index = AudioServer.get_bus_index("SFX")


func change_volume_master(value:float) -> void:
	AudioServer.set_bus_volume_db(master_index, linear_to_db(value))
	volume_master = value


func change_volume_music(value:float) -> void:
	AudioServer.set_bus_volume_db(music_index, linear_to_db(value))
	volume_music = value


func change_volume_sound(value:float) -> void:
	AudioServer.set_bus_volume_db(sound_index, linear_to_db(value))
	volume_sound = value


func play_sound(song_name:String):
	var path = "res://audio/%s" % song_name
	sounds_audio_stream_player.stream = load(path)
	sounds_audio_stream_player.play()

func play_music(song_name:String):
	if song_name == "":
		music_audio_stream_player.stop()
	else:
		var path = "res://audio/song/%s" % song_name
		music_audio_stream_player.stream = load(path)
		music_audio_stream_player.play()
	
func connect_finished(callable:Callable):
	music_audio_stream_player.finished.connect(callable)
	
func disconnect_finished(callable:Callable):
	music_audio_stream_player.finished.disconnect(callable)
