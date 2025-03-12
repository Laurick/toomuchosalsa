extends Node2D

@onready var music_note_scene:PackedScene = preload("res://music_note.tscn")

func _ready() -> void:
	spawn_left()

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("LeftKey"):
		check_notes($SpawnerLeft)
	if Input.is_action_just_pressed("RightKey"):
		check_notes($SpawnerRight)


func spawn_right():
	var music_note = music_note_scene.instantiate()
	music_note.center = $"../Center/Marker2D"
	$SpawnerRight.add_child(music_note)
	
func spawn_left():
	var music_note = music_note_scene.instantiate()
	music_note.center = $"../Center/Marker2D"
	$SpawnerLeft.add_child(music_note)
	
func check_notes(side_node):
	for note:Node2D in side_node.get_children():
		var marker:Marker2D = note.get_child(1)
		var distance:float = abs(marker.global_position.distance_to($"../Center/Marker2D".global_position))
		print(distance)
		if  distance< 60:
			$"..".balance_score += 1 
			note.queue_free()
		else: 
			$"..".balance_score -= 1 
		#TODO ver tema puntuaciones
		$"..".score = $"..".score + ($"..".balance_score)
			
