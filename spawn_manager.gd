extends Node2D

@onready var music_note_scene:PackedScene = preload("res://music_note.tscn")
var song_array:Array = []
var time=0
var spawned_notes = []

func _ready() -> void:
	var parser = SonParser.new()
	var song= parser.parse_song('salsa')
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
	music_note.center = $"../Center/Marker2D"
	music_note.main = $".."
	$SpawnerRight.add_child(music_note)
	
func spawn_left(note):
	var music_note = music_note_scene.instantiate()
	music_note.setup(note.input)
	music_note.center = $"../Center/Marker2D"
	music_note.main = $".."
	$SpawnerLeft.add_child(music_note)
	
func check_notes(side_node):
	for note:Node2D in side_node.get_children():
		var marker:Marker2D = note.get_child(1)
		var distance:float = abs(marker.global_position.distance_to($"../Center/Marker2D".global_position))
		print(distance)
		if  distance< 60:
			$"..".success()
			note.queue_free()
		else: 
			$"..".fail()

		
			
