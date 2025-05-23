class_name SpawnManager extends Node2D

signal note_success(perfect:bool)
signal note_failed()

@export var color_left:Color
@export var color_right:Color

@onready var banner_scene:PackedScene = preload("res://result_banner.tscn")
@onready var center: Marker2D = $"../Center/Marker2D"
@onready var music_note_scene:PackedScene = preload("res://music_note.tscn")
@onready var compass_large:PackedScene = preload("res://compass_large.tscn")
@onready var compass_short:PackedScene = preload("res://compass_short.tscn")

var song_array:Array = []

var spawned_notes = []
var time = 0
var draw_compass_large = true
var time_for_compass:float = 0
var _active = false

func _ready() -> void:
	draw_compass_large = false
	time_for_compass = 0


func play_song(song_string:String) -> void:
	var parser = SonParser.new()
	var song = parser.parse_song(song_string)
	for i in song.keys():
		var side:Constants.SPAWN
		if i == 'l':
			side = Constants.SPAWN.LEFT
		elif i  == 'r':
			side = Constants.SPAWN.RIGHT
		for t in song[i].keys():
			song_array.append({
				"side": side,
				"time":float(t),
				"input":song[i][t].input,
				"type":song[i][t].type, 
			})
	song_array.sort_custom(func(a,b ):return float(a.time)<float(b.time))
	time = AudioManager.get_delay()
	if song_array.size() > 0 and song_array[0].time == 0:
		spawn_note(song_array[0])
	_active = song_array.size() > 0

func _process(delta: float) -> void:
	if !_active: return
	
	if !Constants.spectator_mode:
		if Input.is_action_just_pressed("LeftKey"):
			check_notes($SpawnerLeft)
			AudioManager.play_sound_random_pitch("heels_SFX2.wav")
		if Input.is_action_just_pressed("RightKey"):
			check_notes($SpawnerRight)
			AudioManager.play_sound_random_pitch("heels_SFX2.wav")
	
	if song_array.is_empty(): return
	var note_time:float = song_array[0].time
	var a = note_time-time
	if a < 0.016: # a frame
		spawn_note(song_array[0])
	time += delta

func spawn_note(note):
	if note.side == Constants.SPAWN.LEFT:
		spawn_left(note)
		spawned_notes.append(note)
		song_array.pop_at(0)
			
	elif note.side == Constants.SPAWN.RIGHT:
		spawn_right(note)
		spawned_notes.append(note)
		song_array.pop_at(0)

func spawn_right(note):
	var music_note = music_note_scene.instantiate()
	music_note.setup(note.input, color_right, note.type)
	music_note.center = center
	music_note.note_failed.connect(_note_away)
	music_note.note_auto.connect(_note_auto)
	$SpawnerRight.add_child(music_note)

func spawn_left(note):
	var music_note = music_note_scene.instantiate()
	music_note.setup(note.input, color_left, note.type)
	music_note.center = center
	music_note.note_failed.connect(_note_away)
	music_note.note_auto.connect(_note_auto)
	$SpawnerLeft.add_child(music_note)

func check_notes(side_node):
	if side_node.get_child_count() == 0:
		print("no notes")
		return
	var note:Node2D = side_node.get_child(0)
	if !note or !note.visible:
		print("note invisible")
		return
	var marker:Marker2D = note.get_child(1)
	var distance:float = abs(marker.global_position.distance_to(center.global_position))

	var banner = banner_scene.instantiate()
	#print(distance)
	if distance < 28:
		banner.set_perfect()
		note.succeded = true
		note_success.emit(note._type == Constants.TYPES.HOLD)
		note.queue_free()
	elif  distance < 70:
		note.succeded = true
		banner.set_good()
		note_failed.emit()
		note.queue_free()
	else: 
		banner.set_bad()
		note_failed.emit()
	banner.global_position = center.global_position
	banner.global_position.y -= 100
	add_child(banner)

func _note_auto(note):
	var banner = banner_scene.instantiate()
	banner.set_perfect()
	note.succeded = true
	note_success.emit(note._type == Constants.TYPES.HOLD)
	note.queue_free()
	banner.global_position = center.global_position
	banner.global_position.y -= 100
	add_child(banner)

var can_show_err:bool = true

func _note_away():
	if !can_show_err: return
	can_show_err = false
	var banner = banner_scene.instantiate()
	banner.set_bad()
	banner.global_position = center.global_position
	banner.global_position.y -= 100
	add_child(banner)
	note_failed.emit()
	get_tree().create_timer(0,2, false).timeout.connect(func (): can_show_err = true)
