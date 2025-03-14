class_name SpawnManager extends Node2D

signal note_success(perfect:bool)
signal note_failed()

@onready var banner_scene:PackedScene = preload("res://result_banner.tscn")
@onready var center: Marker2D = $"../Center/Marker2D"
@onready var music_note_scene:PackedScene = preload("res://music_note.tscn")

var song_array:Array = []
var spawned_notes = []
var time = 0

func play_song(song_string:String) -> void:
	time = 0
	var parser = SonParser.new()
	var song= parser.parse_song(song_string)
	for i in song.keys():
		var side:Constants.SPAWN
		if i == 'l':
			side = Constants.SPAWN.LEFT
		elif i  == 'r':
			side = Constants.SPAWN.RIGHT
		for t in song[i].keys():
			print(song[i][t].type)
			song_array.append({
				"side": side,
				"time":float(t),
				"input":song[i][t].input,
				"type":song[i][t].type, 
			})
	song_array.sort_custom(func(a,b ):return float(a.time)<float(b.time))

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("LeftKey"):
		check_notes($SpawnerLeft)
	if Input.is_action_just_pressed("RightKey"):
		check_notes($SpawnerRight)
	time +=delta
	if song_array.is_empty():
		return
	var rounded_time:float = float("%.3f" % (time))
	var note_time:float = float("%.3f" % (song_array[0].time) )
	#print(str(rounded_time) + '-' + str(note_time))
	if abs(rounded_time - note_time) < 0.100:
		var note = song_array[0]
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
	music_note.setup(note.input)
	music_note.center = center
	music_note.note_failed.connect(func (): note_failed.emit())
	$SpawnerRight.add_child(music_note)
	
func spawn_left(note):
	var music_note = music_note_scene.instantiate()
	music_note.setup(note.input)
	music_note.center = center
	music_note.note_failed.connect(func (): note_failed.emit())
	$SpawnerLeft.add_child(music_note)

func check_notes(side_node):
	var note:Node2D = side_node.get_child(0)
	if !note:
		return
	var marker:Marker2D = note.get_child(1)
	var distance:float = abs(marker.global_position.distance_to(center.global_position))

	var result_color:Color
	#print(distance)
	if distance < 60:
		print('perfect')
		result_color = Color.GOLD
		note_success.emit(true)
		note.queue_free()
	elif  distance< 120:
		print('OK')
		result_color = Color.GREEN
		note_success.emit(false)
		note.queue_free()
	else: 
		print('fail')
		result_color = Color.RED
		note_failed.emit()
	var banner = banner_scene.instantiate()
	banner.global_position = center.global_position
	var g = GradientTexture1D.new()
	g.gradient = Gradient.new()
	g.gradient.set_color(0,result_color)
	banner.set_image(g)
	add_child(banner)
