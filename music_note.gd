extends Node2D

signal note_failed()
signal note_auto(note)

@export var center:Marker2D
@onready var note_image: Sprite2D = $NoteImage

var succeded = false
var velocity = 500
var appear
var arrival = false
var leaving = false
var frames_spare = 12

var _arrow: Constants.INPUTS
var _color: Color
var _type: Constants.TYPES
var direction:Vector2
var last_distance: float = 99999

var trail_frames = 2
var _frames = 0

func _ready() -> void:
	appear = Time.get_ticks_msec()
	
	direction = global_position.direction_to(center.global_position)
	match (_arrow):
		Constants.INPUTS.LEFT:
			note_image.texture = load("res://images/arrow_left.png")
		Constants.INPUTS.RIGHT:
			note_image.texture = load("res://images/arrow_right.png")
		Constants.INPUTS.UP:
			note_image.texture = load("res://images/arrow_up.png")
		Constants.INPUTS.DOWN:
			note_image.texture = load("res://images/arrow_down.png")
		Constants.INPUTS.SPACE:
			note_image.texture = load("res://images/button.png")
	note_image.modulate = _color

func setup(arrow:Constants.INPUTS, color:Color, type: Constants.TYPES):
	_arrow = arrow
	_color = color
	_type = type

func _process(delta: float) -> void:
	if leaving: 
		frames_spare -= 1
		if frames_spare == 0:
			check()
		return

	var d =  global_position.distance_to(center.global_position)
	if arrival:
		leaving = true
		create_tween().tween_property(self, "modulate:a", 0, 0.192)
		# print(name+" tarda: " +str(Time.get_ticks_msec()-appear))
	else:
		global_position = global_position + (velocity*delta*direction)
		if last_distance < d or d < 0.8:
			global_position = center.global_position
			if Constants.spectator_mode:
				note_auto.emit(self)
			arrival = true
	last_distance = d
	if _frames == trail_frames:
		_frames = 0
		create_trail()
	else:
		_frames += 1


func create_trail():
	var trail = preload("res://trail.tscn").instantiate()
	trail.global_position = global_position
	trail.texture = note_image.texture
	trail.modulate = _color
	get_tree().get_root().add_child(trail)

func check():
	if !succeded:
		visible = false
		#print(name+" se fue: " +str(Time.get_ticks_msec()-appear))
		note_failed.emit()
		queue_free()
