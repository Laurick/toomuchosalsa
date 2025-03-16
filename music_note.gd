extends Node2D

signal note_failed()

var succeded = false
@onready var note_image: Sprite2D = $NoteImage
var velocity = 8
@export var center:Marker2D
var first = false
var appear

var _arrow:Constants.INPUTS
var _color:Color

func _ready() -> void:
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

func setup(arrow:Constants.INPUTS, color:Color):
	_arrow = arrow
	_color = color

func _process(delta: float) -> void:
	
	if !first:
		#print(global_position.distance_to(center.global_position))
		appear = Time.get_ticks_msec()
		first = true
	global_position = global_position + (velocity*global_position.direction_to(center.global_position))
	if !succeded and global_position.distance_to(center.global_position) <velocity:
		note_failed.emit()
		#print("tarda: " +str(Time.get_ticks_msec()-appear))
		queue_free()
